//
//  CardModel.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation

/*
 {
 "merchantSiteId":"1811",
 "environment":"test",
 "sessionToken":"3b2259be-192a-4ca9-832d-01d6a8a26577",
 "billingAddress":{
 "city":"Berlin",
 "country":"DE",
 "zip":"10021",
 "email":"janedoe@mail.com",
 "firstName":"Jane",
 "lastName":"Doe",
 "state":"None"
 },
 "cardData":{
 "cardNumber":"4111111111111111",
 "cardHolderName":"John Doe",
 "expirationMonth":"01",
 "expirationYear":"2020",
 "CVV":"123"
 }
 }
 */

/*
{
    "ccTempToken":"9a58ab98-3f4e-40c6-ad5b-25ee85f3778e",
    "sessionToken":"4861ec7e-0514-4af1-9a41-aabdfb99d268",
    "internalRequestId":62913,
    "status":"SUCCESS",
    "errCode":0,
    "reason":"",
    "version":"1.0"
} */



enum BillingAddressModelError:Error{
    case invalidData()
}

struct BillingAddressModel {
    public var city:String?
    public var country:String?
    public var zip:String?
    public var email:String?
    public var firstName:String?
    public var lastName:String?
    public var state:String?
    
    init?(representation:[String:Any]) {
        self.city = representation["city"] as? String
        self.country = representation["country"] as? String
        self.zip = representation["zip"] as? String
        self.email = representation["email"] as? String
        self.firstName = representation["firstName"] as? String
        self.lastName = representation["lastName"] as? String
        self.state = representation["state"] as? String
    }
    
    public func asDictionary() throws -> [String:Any] {
        var result:[String:Any] = [:]
        if self.city == nil ||
            self.country == nil ||
            self.zip == nil ||
            self.email == nil ||
            self.firstName == nil ||
            self.lastName == nil ||
            self.state == nil {
            
            throw BillingAddressModelError.invalidData()
        }
        
        result["city"] = self.city
        result["country"] = self.country
        result["zip"] = self.zip
        result["email"] = self.email
        result["firstName"] = self.firstName
        result["lastName"] = self.lastName
        result["state"] = self.state
        
        
        return result
    }
}




enum CardDataModelError:Error{
    case invalidData()
}
struct CardDataModel {
    public var cardNumber:String?
    public var cardHolderName:String?
    public var expirationMonth:String?
    public var expirationYear:String?
    public var CVV:String?
    
    
    init?(representation:[String:Any]) {
        self.cardNumber = representation["cardNumber"] as? String
        self.cardHolderName = representation["cardHolderName"] as? String
        self.expirationMonth = representation["expirationMonth"] as? String
        self.expirationYear = representation["expirationYear"] as? String
        self.CVV = representation["CVV"] as? String
    }
    
    public func asDictionary() throws -> [String:Any] {
        var result:[String:Any] = [:]
        
        if self.cardNumber == nil ||
            self.cardHolderName == nil ||
            self.expirationMonth == nil ||
            self.expirationYear == nil ||
            self.CVV == nil {
            throw CardDataModelError.invalidData()
        }
        
        result["cardNumber"] = self.cardNumber
        result["cardHolderName"] = self.cardHolderName
        result["expirationMonth"] = self.expirationMonth
        result["expirationYear"] = self.expirationYear
        result["CVV"] = self.CVV
        
        return result
    }
}

struct CardModel {
    
    public var sessionToken:String!
    public var cardData:CardDataModel!
    
    public var merchantSiteId:String?
    public var environment:String?
    
    public var billingAddress:BillingAddressModel?

    
    
    
    init?(representation:[String:Any]) {
        self.merchantSiteId = nil
        self.environment = nil
        self.sessionToken = nil
        self.billingAddress = nil
        self.cardData = nil
        
        guard let sessionToken = representation["sessionToken"] as? String else {
            return
        }
        self.sessionToken = sessionToken
        
        guard let cardData = CardDataModel.init(representation: representation["cardData"] as! [String:Any] )  else {
            return
        }
        self.cardData = cardData
        
        self.merchantSiteId = representation["merchantSiteId"] as? String
        self.environment = representation["environment"] as? String
        self.billingAddress = BillingAddressModel.init(representation: representation["billingAddress"] as! [String:Any] )
        
    }
    
}
