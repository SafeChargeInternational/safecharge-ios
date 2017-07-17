//
//  ServiceSession.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import Alamofire

struct ServiceSession {
    open class DisableServerTrustPolicyManager: ServerTrustPolicyManager {
        
        // Override this function in order to trust any self-signed https
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            
            return ServerTrustPolicy.disableEvaluation
        }
    }
    
    public static let sharedSession:SessionManager = {
        let serverTrustPoliciyManager = DisableServerTrustPolicyManager.init(policies: [:])
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let instance = SessionManager.init(configuration: configuration,
                                           delegate: SessionDelegate(),
                                           serverTrustPolicyManager: serverTrustPoliciyManager)
        return instance
    }()

}
