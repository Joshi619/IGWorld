//
//  APICall.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import Alamofire
import SwiftyJSON

open class ApiCall {
    
    @discardableResult
    public static func getGallaryList(loader: Bool = false,success: @escaping SuccessClosure, failure: @escaping FailureClosure) -> Request {
        let headers = ["Accept": "application/json"]
        let requestParameter = RequestParameter.createRequestParameter(.photos, method: .get, headers: headers)
        return NetworkManagerWrapper.makeRequest(requestParameter,loader: loader, encoding: JSONEncoding.default, success: success, failure: failure)
    }
    
}
