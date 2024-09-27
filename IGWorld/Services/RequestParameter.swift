//
//  RequestParameter.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import Alamofire
import SwiftyJSON

open class RequestParameter {
    
    var url: String
    
    /// Method type e.g. GET/POST etc.
    var method: Alamofire.HTTPMethod
    
    /// Headers needed for the api call
    var headers: [String: String]?
    
    /// Url encoded parameters
    var parameters: [String: Any]?
    
    fileprivate init(url: String, method: Alamofire.HTTPMethod, headers: [String: String]? = nil, parameters: [String: Any]? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.parameters = parameters
    }
    
    internal static func createRequestParameter(_ url: ApiCall.EndPoint, method: Alamofire.HTTPMethod, headers: [String: String]? = nil, parameters: [String: Any]? = nil) -> RequestParameter {
        debugPrint("url is : \(url)")
        return RequestParameter(url: url.path, method: method, headers: headers, parameters: parameters)
    }
    
    internal static func createRequestParameterWithURL(_ url: String, method: Alamofire.HTTPMethod, headers: [String: String]? = nil, parameters: [String: Any]? = nil) -> RequestParameter {
        debugPrint("url is : \(url)")
        return RequestParameter(url: url, method: method, headers: headers, parameters: parameters)
    }
    
    internal static func createRequestParameter(_ url: ApiCall.EndPoint, method: Alamofire.HTTPMethod,id:String, headers: [String: String]? = nil, parameters: [String: Any]? = nil) -> RequestParameter {
        debugPrint("url is : \(url)")
        return RequestParameter(url: url.path+"/\(id)", method: method, headers: headers, parameters: parameters)
    }
    
}


struct BodyStringEncoding: ParameterEncoding {
    
    private let body: String
    
    init(body: String) { self.body = body }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        guard var urlRequest = urlRequest.urlRequest else { throw Errors.emptyURLRequest }
        guard let data = body.data(using: .utf8) else { throw Errors.encodingProblem }
        urlRequest.httpBody = data
        return urlRequest
    }
}

extension BodyStringEncoding {
    enum Errors: Error {
        case emptyURLRequest
        case encodingProblem
    }
}
