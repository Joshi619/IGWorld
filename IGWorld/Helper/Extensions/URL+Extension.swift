//
//  URL+Extension.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import MobileCoreServices

extension URL {
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    var containsImage: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeImage)
    }
    var containsAudio: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }
    var containsVideo: Bool {
        let mimeType = self.mimeType()
        guard  let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeMovie)
    }
    
    func downLoadURL(_ completion: ((_ url: URL?,_ data: Data?) -> Void)?) {
        URLSession.shared.dataTask(with: self) { data, response, error in
                if let url = response?.url {
                    completion?(url, data)
                } else {
                    completion?(nil, nil)
                }
            }.resume()
        }
}

// MARK: - UserDefaults
extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
           if let data = try? JSONEncoder().encode(encodable) {
               set(data, forKey: key)
           }
       }

       func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
           if let data = object(forKey: key) as? Data,
               let value = try? JSONDecoder().decode(type, from: data) {
               return value
           }
           return nil
       }
    
    func decode<T : Codable>(for type : T.Type, using key : String) -> T? {
        let defaults = UserDefaults.standard
        guard let data = defaults.object(forKey: key) as? Data else {return nil}
        let decodedObject = try? PropertyListDecoder().decode(type, from: data)
        return decodedObject
    }
    
    func encode<T : Codable>(for type : T, using key : String) {
        let defaults = UserDefaults.standard
        let encodedData = try? PropertyListEncoder().encode(type)
        defaults.set(encodedData, forKey: key)
    }
}
