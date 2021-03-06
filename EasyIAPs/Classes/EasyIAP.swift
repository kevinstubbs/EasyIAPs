//
//  IAPHelpers.swift
//
//  Created by SwiftCoder.Club on 05/05/16.
//  Copyright (c) 2016 SwiftCoder.Club. All rights reserved.
//

import UIKit
import StoreKit
import Foundation
import SVProgressHUD

//MARK: SKProductsRequestDelegate

extension EasyIAP : SKProductsRequestDelegate
{
     func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse)
    {
        if response.products.count > 0
        {
            let validProduct = response.products[0]
            validProduct.productIdentifier == self.currnetProductIdentifier ? self.buyProduct(validProduct) : self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.NoProductFound)
            
        } else {
            
            self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.NoProducts)
            
            // Stop Activity Indicator
            
            self.hideActivityIndicator()
        }
    }
}

//MARK: SKRequestDelegate

extension EasyIAP : SKRequestDelegate
{
     func requestDidFinish(request: SKRequest)
    {
    }
    
     func request(request: SKRequest, didFailWithError error: NSError)
    {
        self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.ProductRequestFailed)
    }
}

//MARK: SKPaymentTransactionObserver

extension EasyIAP : SKPaymentTransactionObserver
{
     func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
    {
        self.handlingTransactions(transactions)
    }
    
     func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue)
    {
        queue.transactions.count == 0 ? self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.DidntMakeAnyPayments)  : self.handlingTransactions(queue.transactions)
    }
    
     func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError)
    {
        // Stop Activity Indicator
        
        self.hideActivityIndicator()
        
        self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.CouldNotRestore)
    }
}

//MARRK: EasyIAP

class EasyIAP : NSObject {
    
    //MARK: Variables
    
    private let restorePurchaseIdentifier = "RESTORE_PURCHASE"
    private var receiptValidationServer = String()
    private var currnetProductIdentifier = String()
    private var loaderRingColor = UIColor.whiteColor()

    private var EasyIAPCompletionBlock : ((success : Bool, error : EasyIAPErrorType?) -> ())?
    
    //MARRK: startProductRequest
    
    func startProductRequest(productReferenceName : String, receiptValidatingServerURL : String, restore : Bool, loaderRingColor : UIColor, completion : (success : Bool, error : EasyIAPErrorType?) -> ()) {
        
        self.EasyIAPCompletionBlock = completion

        if Platform.isSimulator {
            
            self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.CantRunInSimulator)
        }
        else {
            
            self.loaderRingColor = loaderRingColor
            
            if restore
            {
                self.currnetProductIdentifier = self.restorePurchaseIdentifier
            }
            else
            {
                self.currnetProductIdentifier = productReferenceName
            }
            
            self.receiptValidationServer = receiptValidatingServerURL
            self.showActivityIndicator()
            self.start()
        }
    }
    
    //MARK: Product Request
    
    private func start()
    {
        if let _ = NSURL(string: self.receiptValidationServer) {
            
            if (SKPaymentQueue.canMakePayments()) {
                
                if self.currnetProductIdentifier == self.restorePurchaseIdentifier
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
                
                
                // Stop Activity Indicator
                
                self.hideActivityIndicator()
                
                // Can't make payments
                
                self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.CantMakePayments)
            }
        }
        else {
            
            
            // Stop Activity Indicator
            
            self.hideActivityIndicator()
            
            // Not a valid Receipt URL
            
            self.EasyIAPCompletionBlock!(success: false, error: EasyIAPErrorType.NotAValidReceiptURL)
        }
 
    }
    
    //MARK: Buy Product - Payment Section
    
    private func buyProduct(product : SKProduct)
    {
        // Show Activity Indicator
        
        self.showActivityIndicator()
        
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
    
    //MARK: Transaction Observer Handler
    
    private func handlingTransactions(transactions : [AnyObject])
    {
        // Show Activity Indicator
        
        self.showActivityIndicator()
        
        for transaction in transactions {
            
            if let paymentTransaction : SKPaymentTransaction = transaction as? SKPaymentTransaction {
                
                switch paymentTransaction.transactionState {
                    
                case .Purchasing :
                    
                    print("Purchasing")
                    
                case .Purchased :
                    
                    print("Purchased")
                    self.deliverProduct(paymentTransaction.payment.productIdentifier)
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    
                case .Failed:
                    
                    print("Failed")
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    
                case .Restored:
                    
                    print("Restored")
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    self.restoreTransaction(paymentTransaction)
                    
                case .Deferred:
                    
                    print("Deferred")
                }
            }
        }
    }
    
    //MARK: Deliver Product
    
    private func deliverProduct(product : String)
    {
        // Show Activity Indicator
        
        self.showActivityIndicator()
        
        self.validateReceipt { status , error in
            
            status ? self.EasyIAPCompletionBlock!(success: true, error: nil) : self.EasyIAPCompletionBlock!(success: false, error: error)
            
            // Stop Activity Indicator
            
            self.hideActivityIndicator()
        }
    }
    
    
    //MARK: Receipt Validation
    
    private func validateReceipt(completion : (status : Bool, error : EasyIAPErrorType?) -> ())  {
        
        if let receiptUrl = NSBundle.mainBundle().appStoreReceiptURL, urlPath = receiptUrl.path
        {
            if NSFileManager.defaultManager().fileExistsAtPath(urlPath)
            {
                if let receipt = NSData(contentsOfURL: receiptUrl)
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
                        
                        if let properData = data
                        {
                            self.handleResponseFromServer(properData, completion: { status, error in
                                
                                completion(status: status, error:  error)
                            })
                        }
                        else
                        {
                            completion(status: false, error:  EasyIAPErrorType.NoResponseFromServer)
                        }
                    })
                    
                    task.resume()
                }
                else
                {
                    completion(status: false, error:  EasyIAPErrorType.CouldNotConvertReceiptURLToNSData)
                }
            }
            else
            {
                completion(status: false, error:  EasyIAPErrorType.ReceiptURLDoesNotExists)
            }
        }
        else
        {
            completion(status: false, error:  EasyIAPErrorType.ReceiptURLDoesNotExists)
        }
    }
    
    private func handleResponseFromServer(responseDatas : NSData, completion : (status : Bool, error : EasyIAPErrorType?) -> ())
    {
        do
        {
            if let json = try NSJSONSerialization.JSONObjectWithData(responseDatas, options: NSJSONReadingOptions.MutableLeaves) as? NSDictionary
            {
                if let value = json.valueForKeyPath("status") as? Int
                {
                    value == 0 ? completion(status: true, error: nil) : completion(status: false, error:  value.easyIAPErrorType)
                }
            }
            else
            {
                completion(status: false, error:  EasyIAPErrorType.StatusKeyDoesNotExistsInJSON)
            }
        }
        catch
        {
            completion(status: false, error:  EasyIAPErrorType.CoultNotParseJSONFromRecieptServer)
        }
    }
    
    //MARK: Show Activity
    
    private func showActivityIndicator()
    {
        dispatch_async(dispatch_get_main_queue()) {
            
            SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
            SVProgressHUD.setForegroundColor(self.loaderRingColor)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
            SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.Flat)
            SVProgressHUD.show()
        }
    }
    
    //MARK: Hide Activity

    private func hideActivityIndicator()
    {
        dispatch_async(dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
        }
    }
}








