//
//  ServiceResponseGeneric.swift
//  PaymentDemoApp
//
//  Created by Miroslav Chernev on 7/10/17.
//  Copyright © 2017 Miroslav Chernev. All rights reserved.
//

import Foundation
import Alamofire

enum BackendError: Error {
    case network(error: Error)
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case objectSerialization(reason: String)
    case paycomService(reason:Error)
}

protocol ResponseObjectSerializable {
    
    init?(representation:Any)
    //init?(response: HTTPURLResponse, representation: Any)
    
    func getError() -> Error?
}

extension DataRequest {
    
    @discardableResult
    func responseObject<T: ResponseObjectSerializable>
        ( queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) ->Void ) -> Self {
        
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard response != nil else {
                return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }
            
            
            let responseObject = T(representation:jsonObject)
            
            if responseObject == nil {
                return .failure(BackendError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }
            
            if( responseObject != nil && responseObject?.getError() != nil ) {
                return .failure(responseObject!.getError()!)
            }
            
            return .success(responseObject!)
        }
        
        return response(queue: queue,
                        responseSerializer: responseSerializer,
                        completionHandler: completionHandler)
    }
}

