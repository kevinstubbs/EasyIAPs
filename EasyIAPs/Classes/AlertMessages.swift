//
//  AlertMessages.swift
//  Pods
//
//  Created by Alvin Varghese on 5/28/16.
//
//

import Foundation
import UIKit

//MARK: Alert Messages

public enum EasyIAPErrorType : Int
{
    // Receipt validation error
    
    case CouldNotReadJSON = 21000, DataMalformedOrMissing = 21002, CouldNotAuthenticate, DoesNotMatchSharedSecret, ReceiptServerNotAvailable, SubscriptionExpired, TestEnvironmentReceipt, ProductionEnvironmentReceipt
    
    // In App Purchase error
    
    case NoProducts = 100, NoProductFound, CantMakePayments, NotAValidReceiptURL, DidntMakeAnyPayments, CouldNotRestore, ProductRequestFailed, CoultNotParseJSONFromRecieptServer, StatusKeyDoesNotExistsInJSON, CouldNotConvertReceiptURLToNSData, ReceiptURLDoesNotExists, CouldNotReadAppStoreReceiptURL, NoResponseFromServer
}

extension EasyIAPErrorType
{
    var description : String {
        
        switch self
        {
            // Receipt validation error
            
        case .CouldNotReadJSON : return "The App Store could not read the JSON object you provided"
        case .DataMalformedOrMissing : return "The data in the receipt-data property was malformed or missing"
        case .CouldNotAuthenticate : return "The receipt could not be authenticated"
        case .DoesNotMatchSharedSecret : return "The shared secret you provided does not match the shared secret on file for your account"
        case .ReceiptServerNotAvailable : return "The receipt server is not currently available"
        case .SubscriptionExpired : return "This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response"
        case .TestEnvironmentReceipt : return "This receipt is from the test environment, but it was sent to the production environment for verification. Send it to the test environment instead"
        case .ProductionEnvironmentReceipt : return "This receipt is from the production environment, but it was sent to the test environment for verification. Send it to the production environment instead"
            
            // In App Purchase error
            
        case .NoProducts : return "There are no products"
        case .NoProductFound : return "No product found"
        case .CantMakePayments : return "You can not make payments"
        case .NotAValidReceiptURL : return "Not a valid url, Please check your receipt validating server url"
        case .DidntMakeAnyPayments : return "You did not make any payments"
        case .CouldNotRestore : return "Could not restore"
        case .ProductRequestFailed : return "Product request failed"
        case .CoultNotParseJSONFromRecieptServer : return "Could not parse JSON recieved from receipt server"
        case .StatusKeyDoesNotExistsInJSON : return "Status key does not exists in receipt response JSON"
        case .CouldNotConvertReceiptURLToNSData : return "Could not convert receipt url to NSData"
        case .ReceiptURLDoesNotExists : return "Receipt URL does not exists"
        case .CouldNotReadAppStoreReceiptURL : return "Could not read App Store receipt URL"
        case .NoResponseFromServer : return "No response from server"
        }
    }
}

extension Int
{
    var easyIAPErrorType : EasyIAPErrorType
    {
        switch self
        {
            // Receipt validation error
            
        case 21000 : EasyIAPErrorType.CouldNotReadJSON
        case 21002 : EasyIAPErrorType.DataMalformedOrMissing
        case 21003 : EasyIAPErrorType.CouldNotAuthenticate
        case 21004 : EasyIAPErrorType.DoesNotMatchSharedSecret
        case 21005 : EasyIAPErrorType.ReceiptServerNotAvailable
        case 21006 : EasyIAPErrorType.SubscriptionExpired
        case 21007 : EasyIAPErrorType.TestEnvironmentReceipt
        case 21008 : EasyIAPErrorType.ProductionEnvironmentReceipt
            
            // In App Purchase error
            
        case 100 : EasyIAPErrorType.NoProducts
        case 101 : EasyIAPErrorType.NoProductFound
        case 102 : EasyIAPErrorType.CantMakePayments
        case 103 : EasyIAPErrorType.NotAValidReceiptURL
        case 104 : EasyIAPErrorType.DidntMakeAnyPayments
        case 105 : EasyIAPErrorType.CouldNotRestore
        case 106 : EasyIAPErrorType.ProductRequestFailed
        case 107 : EasyIAPErrorType.CoultNotParseJSONFromRecieptServer
        case 108 : EasyIAPErrorType.StatusKeyDoesNotExistsInJSON
        case 109 : EasyIAPErrorType.CouldNotConvertReceiptURLToNSData
        case 110 : EasyIAPErrorType.ReceiptURLDoesNotExists
        case 111 : EasyIAPErrorType.CouldNotReadAppStoreReceiptURL
        case 112 : EasyIAPErrorType.NoResponseFromServer
        }
    }
}



