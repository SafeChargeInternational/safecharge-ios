//
//  CardModel.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation


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
    
    init( city: String,
          country: String,
          zip:String,
          email:String,
          firstName:String,
          lastName:String,
          state:String ) {
        
        self.city = city
        self.country = country
        self.zip = zip
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.state = state
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
    
    init(cardNumber:String,
         cardHolderName:String,
         expirationMonth:String,
         expirationYear:String,
         CVV:String) {
        self.cardNumber = cardNumber
        self.cardHolderName = cardHolderName
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.CVV = CVV
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
        
        if let cardDataModelRepresentation = representation["cardData"] as? CardDataModel {
            self.cardData = cardDataModelRepresentation
        } else if let cardDataJsonRepresentation = representation["cardData"] as? [String:Any] {
            self.cardData = CardDataModel.init(representation: cardDataJsonRepresentation)
        } else {
            print("invalid card data")
            return
        }
        
        self.merchantSiteId = representation["merchantSiteId"] as? String
        self.environment = representation["environment"] as? String
        
        if let billingAddressModelRepresentation = representation["billingAddress"] as? BillingAddressModel {
            self.billingAddress = billingAddressModelRepresentation
        } else if let billingAddressJsonRepresentation = representation["billingAddress"] as? [String:Any] {
            self.billingAddress = BillingAddressModel.init(representation: billingAddressJsonRepresentation)
        } else {
            print("ivalid billing address data")
            return
        }
    }
    
}
