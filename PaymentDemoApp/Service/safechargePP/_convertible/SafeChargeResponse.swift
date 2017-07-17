//
//  SafeChargeResponse.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation

enum AuthorizeError : Error {
    case invalidResponse()
    
    case apiError(statusDesc:String,statusCode:Int)
}

struct AuthorizeResponse : ResponseObjectSerializable {
    
    let authorizationData:AuthorizationResponseModel?
    var responseError:AuthorizeError?
    
    func getError() -> Error? {
        return responseError
    }
    
    func constructErrorIfAny() -> AuthorizeError? {
        if self.authorizationData != nil {
            guard let statusCheck = self.authorizationData?.status else {
                return AuthorizeError.invalidResponse()
            }
            
            guard let statusCode = self.authorizationData?.errCode else {
                return AuthorizeError.invalidResponse()
            }
            
            
            if statusCheck != "SUCCESS" {
                return AuthorizeError.apiError(statusDesc: statusCheck, statusCode: statusCode)
            }
        }
        return nil
    }

    init?(representation:Any) {
        guard let representation = representation as? [String:Any] else {
            self.responseError = nil // initialize error
            self.authorizationData = nil
            return
        }
        
        guard let authorizationData = AuthorizationResponseModel.init(dictionary: representation) else {
            self.responseError = nil // initialize error
            self.authorizationData = nil
            return
        }
        self.authorizationData = authorizationData
        self.responseError = nil
        
        self.responseError = self.constructErrorIfAny()
    }
}

enum CardTokenizationError:Error {
    case invalidResponse()
    case invalidCardNumber()
}

struct CardTokenizationResponse : ResponseObjectSerializable {
    var cardTokenziationData:CardTokenizationResponseModel?
    var responseError:CardTokenizationError?
    
    func getError() -> Error? {
        return responseError
    }
    
    init?(representation:Any) {
        self.cardTokenziationData = nil
        self.responseError = nil
        
        guard let representation = representation as? [String:Any] else {
            self.responseError = nil // initialize error
            self.cardTokenziationData = nil
            return
        }
        
        guard let cardTokenziationData = CardTokenizationResponseModel.init(representation: representation) else {
            self.responseError = nil // initialize error
            self.cardTokenziationData = nil
            return
        }
        
        self.cardTokenziationData = cardTokenziationData
        self.responseError = self.constructErrorIfAny()
    }
    
    private func constructErrorIfAny() -> CardTokenizationError? {
        var result:CardTokenizationError? = nil
        
        if self.cardTokenziationData?.status != nil && self.cardTokenziationData?.status != "SUCCESS" {
            
            //if
            
            result = CardTokenizationError.invalidResponse()
        }
        
        return result
    }
}
