//
//  ResponseObject.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation

open class ResponseObject {
  // This is the network status code
  fileprivate var networkStatusCode: Int
  // Status code in the response (in json "{"code":309, etc. etc.}"
  fileprivate var apiStatusCode: Int
  // Message to be displayed to the user, shouldn't be used since we'll map error codes to the user messages
  fileprivate var message: String
  // Status success/failure
  fileprivate var apiStatus: String
  // Debug message for developer
  fileprivate var debugMessage: String
  // Data of type T in the response
  fileprivate var data: AnyObject
  
  public init(networkStatusCode: Int, apiStatusCode: Int, message: String, apiStatus: String, debugMessage: String, data: AnyObject) {
    self.networkStatusCode = networkStatusCode
    self.apiStatusCode = apiStatusCode
    self.message = message
    self.apiStatus = apiStatus
    self.debugMessage = debugMessage
    self.data = data
  }
}
