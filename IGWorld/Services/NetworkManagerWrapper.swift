//
//  NetworkManagerWrapper.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias SuccessClosure = (_ data: Data?,_ status: Int?) -> (Void)
public typealias FailureClosure = (_ error: Error?, _ data: Data?, _ statusCode: Int?) -> (Void)


class NetworkManagerWrapper: NSObject {
    
    static func makeRequest(_ requestParamter: RequestParameter,loader:Bool = true, encoding: ParameterEncoding = URLEncoding.default, success: @escaping SuccessClosure, failure: @escaping FailureClosure) -> Request {
        if loader { Alert.showProgressHud()}
        let request = AF.request(requestParamter.url, method: requestParamter.method, parameters: requestParamter.parameters, encoding: encoding, headers: HTTPHeaders(requestParamter.headers ?? ["":""]))
        print(request.convertible)
//        AF.session.configuration.timeoutIntervalForRequest = 120
        request.responseData { (dataResponse) in
            
            #if DEBUG
            if let data = dataResponse.value {
                let responseString = String(data: data, encoding: .utf8)
                if responseString != nil {
                    debugPrint("Response string:\(responseString!)")
                }
                else {
                    //  //debugPrint("Response string is null")
                }
            }
            #endif
            
            if let error = dataResponse.error {
                debugPrint(error)
                if loader { Alert.hideProgressHud()}
                failure(error, dataResponse.value, nil)
            }
            else if dataResponse.response?.statusCode == 200 || dataResponse.response?.statusCode == 201 {
                if loader { Alert.hideProgressHud()}
                success(dataResponse.value, dataResponse.response?.statusCode)
                
            } else {
                if loader { Alert.hideProgressHud()}
                // if status code is not 200 (success)
                failure(nil, dataResponse.value, dataResponse.response?.statusCode)
            }
        }
        return request
    }
    
    static func upload(icon: Data, image : Data, params: [String: Any],_ requestParamter: RequestParameter,loader:Bool = true, encoding: ParameterEncoding = URLEncoding.default, success: @escaping SuccessClosure, failure: @escaping FailureClosure) -> Request  {
        AF.session.configuration.timeoutIntervalForRequest = 120
        let request = AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)}

                    if let temp = value as? Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)}

                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multipartFormData.append(icon, withName: "profilePic", fileName: "profile.png", mimeType: "jpg/png")

                multipartFormData.append(image.base64EncodedData(), withName: "thumbnail")
            },
            to: requestParamter.url, //URL Here
            method: requestParamter.method,
            headers: HTTPHeaders(requestParamter.headers ?? ["":""]))
        print(request.convertible)
        request.responseData { (dataResponse) in

            #if DEBUG
            if let data = dataResponse.value {
                let responseString = String(data: data, encoding: .utf8)
                if responseString != nil {
                    debugPrint("Response string:\(responseString!)")
                }
                else {
                    //  //debugPrint("Response string is null")
                }
            }
            #endif

            if let error = dataResponse.error {
                debugPrint(error)
                if loader { Alert.hideProgressHud()}
                failure(error, dataResponse.value, nil)
            }
            else if dataResponse.response?.statusCode == 200 || dataResponse.response?.statusCode == 201 {
                if loader { Alert.hideProgressHud()}
                success(dataResponse.value, dataResponse.response?.statusCode)

            } else {
                if loader { Alert.hideProgressHud()}
                // if status code is not 200 (success)
                failure(nil, dataResponse.value, dataResponse.response?.statusCode)
            }
        }
        return request
    }
    
    
    static func uploadChatFile(data : Data, mediaType: String = "jpg/png", params: [String: Any],_ requestParamter: RequestParameter,loader:Bool = true, encoding: ParameterEncoding = URLEncoding.default, success: @escaping SuccessClosure, failure: @escaping FailureClosure) -> Request  {
        AF.session.configuration.timeoutIntervalForRequest = 120
        let request = AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)}

                    if let temp = value as? Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)}

                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                if mediaType == "jpg/png" {
                    multipartFormData.append(data, withName: "file", fileName: "file.png", mimeType: mediaType)
                } else if mediaType == "video/mp4"{
                    multipartFormData.append(data, withName: "file", fileName: "file.mp4", mimeType: mediaType)
                } else {
                    multipartFormData.append(data, withName: "file", fileName: "file.pdf", mimeType: mediaType)
                }
               // multipartFormData.append(data.base64EncodedData(), withName: "file")
            },
            to: requestParamter.url, //URL Here
            method: requestParamter.method,
            headers: HTTPHeaders(requestParamter.headers ?? ["":""]))
        print(request.convertible)
        request.responseData { (dataResponse) in

            #if DEBUG
            if let data = dataResponse.value {
                let responseString = String(data: data, encoding: .utf8)
                if responseString != nil {
                    debugPrint("Response string:\(responseString!)")
                }
                else {
                    //  //debugPrint("Response string is null")
                }
            }
            #endif

            if let error = dataResponse.error {
                debugPrint(error)
                if loader { Alert.hideProgressHud()}
                failure(error, dataResponse.value, nil)
            }
            else if dataResponse.response?.statusCode == 200 || dataResponse.response?.statusCode == 201 {
                if loader { Alert.hideProgressHud()}
                success(dataResponse.value, dataResponse.response?.statusCode)

            } else {
                if loader { Alert.hideProgressHud()}
                // if status code is not 200 (success)
                failure(nil, dataResponse.value, dataResponse.response?.statusCode)
            }
        }
        return request
    }
    static func customMakeRequest(_ requestParamter: RequestParameter,loader:Bool = true, encoding: ParameterEncoding = URLEncoding.default, isPassOnBody: Bool = false, success: @escaping SuccessClosure, failure: @escaping FailureClosure) -> Request {
        if loader { Alert.showProgressHud()}
        
        var urlComponent = URLComponents(string: requestParamter.url)!
        let queryItems = requestParamter.parameters?.map{ URLQueryItem(name: $0.key, value: $0.value as? String) }
        urlComponent.queryItems = queryItems
        
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = requestParamter.method.rawValue
        
        if let body = try? JSONSerialization.data(withJSONObject: requestParamter.headers ?? [:]) {
            urlRequest.httpBody = body
        }
        urlRequest.allHTTPHeaderFields = requestParamter.headers
        urlRequest.timeoutInterval = 60
        debugPrint("Request: \n\(urlRequest)")
        AF.session.configuration.timeoutIntervalForRequest = 120
        let request = AF.request(urlRequest).responseData { (dataResponse) in
            
            #if DEBUG
            if let data = dataResponse.value {
                let responseString = String(data: data, encoding: .utf8)
                if responseString != nil {
                    debugPrint("Response string:\(responseString!)")
                }
                else {
                    //  //debugPrint("Response string is null")
                }
            }
            #endif
            
            if let error = dataResponse.error {
                debugPrint(error)
                if loader { Alert.hideProgressHud()}
                failure(error, dataResponse.value, nil)
            }
            else if dataResponse.response?.statusCode == 200 || dataResponse.response?.statusCode == 201 {
                if loader { Alert.hideProgressHud()}
                success(dataResponse.value, dataResponse.response?.statusCode)
                
            } else {
                if loader { Alert.hideProgressHud()}
                // if status code is not 200 (success)
                failure(nil, dataResponse.value, dataResponse.response?.statusCode)
            }
        }
        return request
    }
}

