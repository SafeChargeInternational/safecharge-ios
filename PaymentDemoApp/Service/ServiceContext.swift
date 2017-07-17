//
//  ServiceContext.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/17/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation


class ServiceContext {
    
    @discardableResult required init(enviorment:ServiceEnviorment,
                  merchantId:String,
                  merchantSiteId:String,
                  clientRequestId:String,
                  secretKey:String) {
        ServiceContext.env = enviorment
        if ServiceContext.env == ServiceEnviorment.integration || ServiceContext.env == ServiceEnviorment.qa {
            ServiceContext.enableServerTrust = false
        } else {
            ServiceContext.enableServerTrust = true
        }
        
        ServiceContext.merchantId = merchantId
        ServiceContext.merchantSiteId = merchantSiteId
        ServiceContext.clientRequestId = clientRequestId
        ServiceContext.secretKey = secretKey
    }
    
    public static var env:ServiceEnviorment? = nil
    public static var enableServerTrust:Bool? = nil
    
    public static var merchantId:String? = nil
    public static var merchantSiteId:String? = nil
    public static var clientRequestId:String? = nil
    public static var secretKey:String? = nil
    
}
