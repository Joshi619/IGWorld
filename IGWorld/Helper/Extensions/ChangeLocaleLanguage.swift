//
//  ChangeLocaleLanguage.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit

private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {

     override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {

    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()

    static func set(language: Language) {
        Bundle.once
        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight
        UserDefaults.standard.set(isLanguageRTL,   forKey: "AppleTextDirection")
        UserDefaults.standard.set(isLanguageRTL,   forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            return
        }
        print(path,"path we get")
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        refreshApp()
        AppUserDefaults.save(value: language.code, forKey: .language)
    }
    static func refreshApp(){
        if UIApplication.shared.keyWindow != nil{
            print("get window ")
//            Switcher.updateRootVC(window: window)
        }
    }
    
}
enum Language: Equatable {
    case english(English)
    case chinese
    case japanese
 
    enum English {
        case us
        case uk
        case australian
        case canadian
        case indian
    }
}

extension Language {

    var code: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "en"
            case .uk:                return "en-GB"
            case .australian:        return "en-AU"
            case .canadian:          return "en-CA"
            case .indian:            return "en-IN"
            }
        case .japanese:             return "ja"
        case .chinese:              return "zh-Hans"
        
        }
    }

    var name: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "English"
            case .uk:                return "English (UK)"
            case .australian:        return "English (Australia)"
            case .canadian:          return "English (Canada)"
            case .indian:            return "English (India)"
            }
            
        case .japanese:              return "ja"
        case .chinese:               return "zh-Hans"
        
        }
    }
    
    var codeForAPI: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "en"
            case .uk:                return "English (UK)"
            case .australian:        return "English (Australia)"
            case .canadian:          return "English (Canada)"
            case .indian:            return "English (India)"
            }
            
        case .japanese:              return "ja"
        case .chinese:               return "zh"
        
        }
    }
    var codeForEntropy: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "english"
            case .uk:                return "English (UK)"
            case .australian:        return "English (Australia)"
            case .canadian:          return "English (Canada)"
            case .indian:            return "English (India)"
            }
            
        case .japanese:              return "japanese"
        case .chinese:               return "chinese_simplified"
        
        }
    }
    
}
extension Language {

    init?(languageCode: String?) {
        guard let languageCode = languageCode else { return nil }
        switch languageCode {
        case "en", "en-US":     self = .english(.us)
        case "en-GB":           self = .english(.uk)
        case "en-AU":           self = .english(.australian)
        case "en-CA":           self = .english(.canadian)
        case "en-IN":           self = .english(.indian)
            
        case "ja":              self = .japanese
        case "zh-Hans":         self = .chinese
        default:                return nil
        }
    }
}
