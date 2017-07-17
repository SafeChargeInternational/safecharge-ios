//
//  SafeChargeRequest.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import Alamofire

enum SafeChargeRequest : URLRequestConvertible {
    case authorize(merchantId:String,merchantSiteId:String,clientRequestId:String,timeStamp:String,checksum:String)
    case tokenize(cardInfo:CardModel)
    
    var method: HTTPMethod {
        switch self {
        case .authorize:
            return .post
        case .tokenize:
            return .post
        }
        
    }        
    
    var path: String {
        switch self {
        case .authorize:
            return "/ppp/api/v1/getSessionToken.do"
        case .tokenize:
            return "/ppp/api/cardTokenization.do"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try ServiceContext.env?.rawValue.asURL()
        guard let url_check = url else {
            throw URLError(_nsError:NSError.init(domain: "invalid URL", code: URLError.badURL.rawValue, userInfo: nil))
        }
        
        var request = try URLRequest.init(url: url_check.appendingPathComponent(self.path),
                                          method: self.method)
        switch self {
        case .authorize(let merchantId,let merchantSiteId,let clientRequestId,let timeStamp,let checksum):
            let params:[String:Any] = ["merchantId":merchantId,
                                       "merchantSiteId":merchantSiteId,
                                       "clientRequestId":clientRequestId,
                                       "timeStamp":timeStamp,
                                       "checksum":checksum]
            
            request = try JSONEncoding.default.encode(request,with:params)
            break
        
        case .tokenize(let cardInfo):
            var params:[String:Any] = ["sessionToken":cardInfo.sessionToken,
                                       "cardData":try cardInfo.cardData.asDictionary()]
            
            if cardInfo.merchantSiteId != nil {
                params["merchantSiteId"] = cardInfo.merchantSiteId
            }
            
            if cardInfo.environment != nil {
                params["environment"] = cardInfo.environment
            }
            
            if cardInfo.billingAddress != nil {
                params["billingAddress"] = try cardInfo.billingAddress?.asDictionary()
            }

            
            request = try JSONEncoding.default.encode(request,with:params)
        }
        
        
        return request
    }
}
