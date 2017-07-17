//
//  ServiceConstants.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation


enum ServiceEnviorment: String {
    case integration = "https://ppp-test.safecharge.com"
    case qa          = "https://srv-bsf-devppptrunk.gw-4u.com"
    case production  = "https://secure.safecharge.com"
    
}
