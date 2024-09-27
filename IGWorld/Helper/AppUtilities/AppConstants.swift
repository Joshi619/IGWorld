//
//  AppConstants.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit
// For testing
let stagebaseUrl = "https://jsonplaceholder.typicode.com"
// For live
let baseUrl = "https://jsonplaceholder.typicode.com"

typealias JSONDictionary = [String : Any]

extension ApiCall {

    enum EndPoint : String {
        case photos = "/photos"
        
        var path : String {
            switch self {
            case .photos:
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    if delegate.server == .production {
                        return baseUrl + self.rawValue
                    } else {
                        return stagebaseUrl + self.rawValue
                    }
                }
                return baseUrl + self.rawValue
            }
        }
    }
}

class AppConstant {
    // need to change
    static let appName = "IGWorld"
    static let lostConnectionMessage = "Internet Connection not Available!"
    static var selectedLanguage:Language = .english(.us)
}

enum ServerInfo {
    case production
    case stage
}
