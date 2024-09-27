//
//  AppUserDefaults.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import SwiftyJSON

enum AppUserDefaults {
    
    static func value(forKey key: Key,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            debugPrint("No Value Found in UserDefaults\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
            
            return JSON.null
        }
        
        return JSON(value)
    }
    
    static func value<T>(forKey key: Key,
                      fallBackValue : T,
                      file : String = #file,
                      line : Int = #line,
                      function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            debugPrint("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return JSON(fallBackValue)
        }
        
        return JSON(value)
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
    
    /// Get object of json type from user defaults.
    /// - Returns: **Codable model**
    static func getUserDefaultsData<T>(key: Key) -> T?  where T: Codable {
        return UserDefaults.standard.decode(for: T.self, using: key.rawValue)
    }
    
    /// Save Model to Userdefaults.
    static func saveObjectDataToUserDefaults<T>(list: T, key: Key) where T: Codable {
        UserDefaults.standard.set(encodable: list, forKey: key.rawValue)
    }
}

// MARK:- KEYS
//==============
extension AppUserDefaults {
    
    enum Key : String {
        case isLogin
        case language
    }
}
