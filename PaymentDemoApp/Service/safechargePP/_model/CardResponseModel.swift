//
//  CardResponseModel.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/11/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation

struct CardTokenizationResponseModel {
    public var ccTempToken:String?
    public var sessionToken:String?
    public var internalRequestId:Int64?
    public var status:String?
    public var errCode:Int?
    public var reason:String?
    public var version:String?
    
    init?(representation:[String:Any]) {
        self.ccTempToken = nil
        self.sessionToken = nil
        self.internalRequestId = nil
        self.status = nil
        self.errCode = nil
        self.reason = nil
        self.version = nil
        
        guard let errCode = representation["errCode"] as? Int else {
            return
        }
        self.errCode = errCode
        
        guard let status = representation["status"] as? String else {
            return
        }
        self.status = status
        
        guard let ccTempToken = representation["ccTempToken"] as? String else {
            return
        }
        self.ccTempToken = ccTempToken
        
        guard let sessionToken = representation["sessionToken"] as? String else {
            return
        }
        self.sessionToken = sessionToken
        
        guard let internalRequestId = representation["internalRequestId"] as? Int64 else {
            return
        }
        self.internalRequestId = internalRequestId
        

        
        guard let reason = representation["reason"] as? String else {
            return
        }
        self.reason = reason
        
        guard let version = representation["version"] as? String else {
            return
        }
        self.version = version
    }
}
