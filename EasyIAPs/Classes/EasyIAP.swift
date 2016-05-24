//
//  IAPHelpers.swift
//  Emoni
//
//  Created by Karky Research Foundation on 02/10/15.
//  Copyright (c) 2015 Karky Research Foundation. All rights reserved.
//

import UIKit
import StoreKit
import Foundation

private enum AlertMessages : String
{
    case frameworkName = "EasyIAP"
    case SORRY = "Oops!"
    case NO_PRODUCTS = "There are no products :("
    case CANT_MAKE_PAYMENTS = "You can not make payments :("
    case NOT_A_VALID_URL = "Not a valid url, Please check your receipt validating server url. :("
    case YOU_DIDNT_MAKE_ANY_PURCHASE = "You did not make any payments :( "
    case COULD_NOT_VALIDATE_THE_RECEIPT = "Could not validate the receipt :("
    
    // Error
    
    case NOT_A_VALID_JSON = "The JSON received from your server is not a valid JSON."
    case NOT_A_VALID_FORMAT = "Not a valid format, Could not find key \"status\" in JSON."
    case NOT_A_VALID_STATUS_NOT_ZERO = "Not a valid receipt, Status not equal to 0."
    case NOT_A_RECEIPT_URL = "Could not get receipt url from the path."
    case COULD_NOT_CONVERT_TO_DATA = "Could not convert receiptURL to NSData."

}

//MARK: SKProductsRequestDelegate

extension EasyIAP : SKProductsRequestDelegate
{
    public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse)
    {
        if response.products.count > 0
        {
            let validProduct : SKProduct = response.products[0]
            
            if validProduct.productIdentifier == self.currnetProductIdentifier
            {
                self.buyProduct(validProduct)
            }
            else
            {
                self.alertThis(AlertMessages.SORRY.rawValue, message: AlertMessages.NO_PRODUCTS.rawValue, current: self.currentViewController)
            }

        } else {
            
            self.alertThis(AlertMessages.SORRY.rawValue, message: AlertMessages.CANT_MAKE_PAYMENTS.rawValue, current: self.currentViewController)
        }
    }
}

extension EasyIAP : SKRequestDelegate
{
   public func requestDidFinish(request: SKRequest)
    {
    }
    
    public func request(request: SKRequest, didFailWithError error: NSError)
    {
        self.alertThis(AlertMessages.SORRY.rawValue, message: "\(error.localizedDescription)", current: self.currentViewController)
    }
}

//MARK: SKPaymentTransactionObserver

extension EasyIAP : SKPaymentTransactionObserver
{
    public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        self.handlingTransactions(transactions)
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue)
    {
        if queue.transactions.count == 0
        {
            self.alertThis(AlertMessages.SORRY.rawValue, message: AlertMessages.YOU_DIDNT_MAKE_ANY_PURCHASE.rawValue, current: self.currentViewController)
        }
        else
        {
            self.handlingTransactions(queue.transactions)
        }
    }
    
    public func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError)
    {
        self.alertThis(AlertMessages.SORRY.rawValue, message: "\(error.localizedDescription)", current: self.currentViewController)
    }
}

public protocol IAPHelperDelegate
{
    func transactionCompletedForRequest(productIdentifier : String, success : Bool)
}

public class EasyIAP : NSObject {
    
    //MARK: Variables
    
    private let restorePurchaseIdentifier = "RESTORE_PURCHASE"
    
    public var delegate : IAPHelperDelegate!
    
    public var currentViewController : UIViewController!
    private var receiptValidationServer = String()
    private var currnetProductIdentifier = String()
    
    public init(target : UIViewController, productReferenceName : String, receiptValidatingServerURL : String) {
        
        self.currentViewController = target
        self.currnetProductIdentifier = productReferenceName
        self.receiptValidationServer = receiptValidatingServerURL
    }
    
    //MARK: Product Request
    
    public func start()
    {
        if let _ = NSURL(string: self.receiptValidationServer) {
            
            if (SKPaymentQueue.canMakePayments()) {
                
                if self.currnetProductIdentifier == "RESTORE_PURCHASE"
                {
                    self.restorePurchases()
                }
                else
                {
                    let productID : Set<String> = [self.currnetProductIdentifier]
                    let productsRequest : SKProductsRequest = SKProductsRequest(productIdentifiers: productID)
                    productsRequest.delegate = self
                    productsRequest.start()
                }
            } else {
                
                // Can't make payments
                
                self.alertThis(AlertMessages.SORRY.rawValue, message: AlertMessages.CANT_MAKE_PAYMENTS.rawValue, current: self.currentViewController)
            }
        }
        else {
            
            // Not a valid URL
            
            self.alertThis(AlertMessages.SORRY.rawValue, message: AlertMessages.NOT_A_VALID_URL.rawValue, current: self.currentViewController)
        }
        
    }
    
    //MARK: Buy Product - Payment Section
    
    private func buyProduct(product : SKProduct)
    {
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    //MARK: Restore Transaction
    
    private func restoreTransaction(transaction : SKPaymentTransaction)
    {
        self.deliverProduct(transaction.payment.productIdentifier)
    }
    
    //MARK: Restore Purchases
    
    private func restorePurchases()
    {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    //MARK: - Showing UIAlertView
    
    private func alertThis(title : String, message : String, current : UIViewController)
    {
        let alertView : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertView.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { _ in
            
        }))
        
        current.presentViewController(alertView, animated: true, completion: nil)
    }
    
    //MARK: Transaction Observer Handler
    
    private func handlingTransactions(transactions : [AnyObject])
    {
        for transaction in transactions {
            
            if let paymentTransaction : SKPaymentTransaction = transaction as? SKPaymentTransaction {
                
                switch paymentTransaction.transactionState {
                    
                case .Purchasing :
                    
                    print("Purchasing")
                    
                case .Purchased :
                    
                    self.deliverProduct(paymentTransaction.payment.productIdentifier)
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .Failed:
                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                case .Restored:
                    
                    print("Restored")
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    self.restoreTransaction(paymentTransaction)
                    break
                    
                default:
                    
                    print("DEFAULT")
                    
                    // PRESENT A USER FOR UI about not being able to make payments.
                    
                    break
                }
            }
        }
    }
    
    //MARK: Deliver Product
    
    private func deliverProduct(product : String)
    {
        self.validateReceipt { status in
            
            if status
            {
                self.delegate.transactionCompletedForRequest(product, success: true)
            }
            else
            {
                self.delegate.transactionCompletedForRequest(product, success: false)
            }
        }
    }
    
    
    //MARK: Receipt Validation
    
    private func validateReceipt(completion : (status : Bool) -> ())  {
        
        let receiptUrl = NSBundle.mainBundle().appStoreReceiptURL!
        
        if NSFileManager.defaultManager().fileExistsAtPath(receiptUrl.path!)
        {
            if let receipt : NSData = NSData(contentsOfURL: receiptUrl)
            {
                let receiptdata: NSString = receipt.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
                
                let dict = ["receipt-data" : receiptdata]
                
                let jsonData = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions(rawValue: 0))
                
                let request = NSMutableURLRequest(URL: NSURL(string: self.receiptValidationServer)!)
                
                let session = NSURLSession.sharedSession()
                request.HTTPMethod = "POST"
                request.HTTPBody = jsonData
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("\(jsonData.length)", forHTTPHeaderField: "Content-Length")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error  in
                    
                    if let dataR = data
                    {
                        self.handleData(dataR, completion: { status in
                            
                            completion(status: status)
                        })
                    }
                })
                
                task.resume()
            }
            else
            {
                completion(status: false)
                print(AlertMessages.COULD_NOT_CONVERT_TO_DATA.rawValue)
            }
        }
        else
        {
            completion(status: false)
            print(AlertMessages.NOT_A_VALID_URL.rawValue)
        }
    }
    
    
    private func handleData(responseDatas : NSData, completion : (status : Bool) -> ())
    {
        do
        {
            if let json = try NSJSONSerialization.JSONObjectWithData(responseDatas, options: NSJSONReadingOptions.MutableLeaves) as? NSDictionary
            {
                if let value = json.valueForKeyPath("status") as? Int
                {
                    if value == 0
                    {
                        completion(status: true)
                    }
                    else
                    {
                        completion(status: false)
                        print(AlertMessages.NOT_A_VALID_STATUS_NOT_ZERO.rawValue)
                    }
                }
                else
                {
                    completion(status: false)
                    print(AlertMessages.NOT_A_VALID_FORMAT.rawValue)

                }
            }
            else
            {
                completion(status: false)
                print(AlertMessages.NOT_A_VALID_JSON.rawValue)
            }
        }
        catch let error as NSError
        {
            completion(status: false)
            print(error.localizedDescription)
        }
    }
    
}

