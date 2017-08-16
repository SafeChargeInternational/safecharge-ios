//
//  AuthorizationModel.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation

struct AuthorizationResponseModel {
    
    public var sessionToken:String?
    public var merchantId:String?
    public var merchantSiteId:String?
    public var clientRequestId:String?
    public var internalRequestId:Int?
    public var status:String?
    public var errCode:Int?
    public var reason:String?
    public var version:String?
    
    init?(dictionary:[String:Any]) {
        
        self.sessionToken = nil
        self.merchantId = nil
        self.merchantSiteId = nil
        self.clientRequestId = nil
        self.internalRequestId = nil
        self.status = nil
        self.errCode = nil
        self.reason = nil
        self.version = nil
        
        guard let status = dictionary["status"] as? String else {
            return
        }
        self.status = status
        
        guard let errCode = dictionary["errCode"] as? Int else {
            return
        }
        self.errCode = errCode
        
        guard let reason = dictionary["reason"] as? String else {
            return
        }
        self.reason = reason
        
        guard let sessionToken = dictionary["sessionToken"] as? String else {
            return
        }
        self.sessionToken = sessionToken
        
        guard let merchantId = dictionary["merchantId"] as? String else {
            return
        }
        self.merchantId = merchantId
        
        
        guard let merchantSiteId = dictionary["merchantSiteId"] as? String else {
            return
        }
        self.merchantSiteId = merchantSiteId
        
        
        guard let clientRequestId = dictionary["clientRequestId"] as? String else {
            return
        }
        self.clientRequestId = clientRequestId
        
        
        guard let internalRequestId = dictionary["internalRequestId"] as? Int else {
            return
        }
        self.internalRequestId = internalRequestId
        
        
        guard let version = dictionary["version"] as? String else {
                return
        }
        self.version = version
        
    }
}
