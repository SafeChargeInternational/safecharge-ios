//
//  SafeChargeAPI.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import Alamofire

struct SafeChargeAPI
{
    
    typealias authorizeCallBack = (_ sessionToken:String?, _ error:Error? ) -> Void
    static func authorize(merchantId:String,
                          merchantSiteId:String,
                          clientRequestId:String,
                          secretKey:String,
                          completition:@escaping(authorizeCallBack)) -> Void {
        
        
        let timeStamp = Date().toStringComponents()
        
        let paramsInput = String.init(merchantId)?
            .appending(merchantSiteId)
            .appending(clientRequestId)
            .appending(timeStamp)
            .appending(secretKey)
        
        let checksum = paramsInput!.sha256()
        
        let request = ServiceSession.sharedSession.request(SafeChargeRequest.authorize(merchantId: merchantId,
                                                                                       merchantSiteId: merchantSiteId,
                                                                                       clientRequestId: clientRequestId,
                                                                                       timeStamp: timeStamp,
                                                                                       checksum: checksum))
        request.responseObject { (response:DataResponse<AuthorizeResponse>) in
            switch response.result {
            case .success:
                let authData = response.value!.authorizationData
                let sessionToken = authData!.sessionToken!
                completition(sessionToken,nil)
                break
            case .failure:
                completition(nil,response.error)
                break
            }
        }
    }
    
    
    typealias tokenizeCallBack = (_ tempToken:String?, _ error:Error? ) -> Void
    static func tokenize(cardInfo:CardModel,completition:@escaping(tokenizeCallBack)) {
        let request = ServiceSession.sharedSession.request(SafeChargeRequest.tokenize(cardInfo: cardInfo))
        request.responseObject { (response:DataResponse<CardTokenizationResponse>) in
            switch response.result {
            case .success:
                let tempToken = response.value?.cardTokenziationData?.ccTempToken
                completition(tempToken!,nil)
                break
            case .failure:
                completition(nil,response.error)
                break
            }
        }
    }
}

