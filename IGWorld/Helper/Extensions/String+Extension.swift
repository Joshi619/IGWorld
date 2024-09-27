//
//  String+Extension.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit

extension String {
    
    public var isNotEmpty: Bool {
           return !isEmpty
       }
       
       
       func satisfiesRegexp(_ regexp: String) -> Bool {
           return range(of: regexp, options: .regularExpression) != nil
       }
    
    func encodeChatString() -> String? {
        if let encodedTextData = self.data(using: .nonLossyASCII) {
            return String(data: encodedTextData, encoding: .utf8)
        }
        
        return nil
    }
    
    func decodeChatString() -> String? {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if let stringData = trimmedString.data(using: .utf8) {
            let messageString = String(data: stringData, encoding: .nonLossyASCII)
            return messageString
        }
        
        return nil
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
    
    var localized:String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    
    static func random(length: Int = 9) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
        
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current//Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.calendar =  Calendar(identifier: Calendar.Identifier.gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.date(from: self)!
    }
    
    func TimeToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current//Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.calendar =  Calendar(identifier: Calendar.Identifier.gregorian)
        dateFormatter.timeZone = TimeZone.current
        let date = "20/01/2021 \(self)"
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        if let date = dateFormatter.date(from: date) {
            return date
        }
        return dateFormatter.date(from: date) ?? Date()
    }
    
    func convertStringtoDate() -> Date?
    {
        let fmt = ISO8601DateFormatter()
        
        return fmt.date(from: self) ?? nil
    }
    
    func changeStringDateFormat(locale:String = "en_US_POSIX", fromDateFormat:String  = "dd/MM/yyyy HH:mm",toDateFormat:String  = "yyyy-MM-dd'T'HH:mm:ssZ") -> String? {
        
        
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        // set locale to reliable US_POSIX
        dateFormatter.dateFormat = fromDateFormat
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = toDateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    func changeStringDateFormatCreate(locale:String = "en_US_POSIX", fromDateFormat:String  = "dd/MM/yyyy HH:mm",toDateFormat:String  = "yyyy-MM-dd'T'HH:mm:ssZ") -> String? {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: locale) // set locale to reliable US_POSIX
        dateFormatter.dateFormat = fromDateFormat
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = toDateFormat
        dateFormatter.locale = tempLocale // reset the locale
        return dateFormatter.string(from: date)
    }
    
    func fetchEndTimeByDurationCreate(locale:String = "en_US_POSIX", fromDateFormat:String  = "dd/MM/yyyy HH:mm",toDateFormat:String  = "yyyy-MM-dd'T'HH:mm:ssZ", duration:Int) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.locale = Locale(identifier: locale) // set locale to reliable US_POSIX
        dateFormatter.dateFormat = fromDateFormat
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = toDateFormat
        dateFormatter.locale = tempLocale // reset the locale
        return dateFormatter.string(from:  date.addingTimeInterval(TimeInterval(duration*60)))
        
    }
    
    func fetchEndTimeByDuration(locale:String = "en_US_POSIX", fromDateFormat:String  = "dd/MM/yyyy HH:mm",toDateFormat:String  = "yyyy-MM-dd'T'HH:mm:ssZ", duration:Int) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        //        let tempLocale = dateFormatter.locale // save locale temporarily
        //        dateFormatter.locale = Locale(identifier: locale) // set locale to reliable US_POSIX
        dateFormatter.dateFormat = fromDateFormat
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = toDateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current// reset the locale
        return dateFormatter.string(from:  date.addingTimeInterval(TimeInterval(duration*60)))
        
    }
    
    func convertToUTC(dateToConvert:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let convertedDate = formatter.date(from: dateToConvert)
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: convertedDate!)
        
    }
    
    func dateServerToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let localDate = dateFormatter.date(from: self) ?? Date()
        
        return dateFormatter.string(from: localDate)
    }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        if #available(iOS 10.2, *) {
            return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
        } else {
            return false
            // Fallback on earlier versions
        }
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { if #available(iOS 10.2, *) {
        return unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false
    } else {
        return false
        // Fallback on earlier versions
    }
    
    }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
    
}

extension Dictionary {
    var JSONData: Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: [.prettyPrinted]) else {
            return nil
        }
        return data
    }
}
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
extension NSMutableAttributedString {
    
    func textString(_ value:String, _ flag:Bool = false , font:UIFont, color:UIColor) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font , .foregroundColor : color
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    //    /* Other styling methods */
    //    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
    //
    //        let attributes:[NSAttributedString.Key : Any] = [
    //            .font :  normalFont,
    //            .foregroundColor : UIColor.white,
    //            .backgroundColor : UIColor.orange
    //        ]
    //
    //        self.append(NSAttributedString(string: value, attributes:attributes))
    //        return self
    //    }
    //
    //    func blackHighlight(_ value:String) -> NSMutableAttributedString {
    //
    //        let attributes:[NSAttributedString.Key : Any] = [
    //            .font :  normalFont,
    //            .foregroundColor : UIColor.white,
    //            .backgroundColor : UIColor.black
    //
    //        ]
    //
    //        self.append(NSAttributedString(string: value, attributes:attributes))
    //        return self
    //    }
    //
    //    func underlined(_ value:String) -> NSMutableAttributedString {
    //
    //        let attributes:[NSAttributedString.Key : Any] = [
    //            .font :  normalFont,
    //            .underlineStyle : NSUnderlineStyle.single.rawValue
    //
    //        ]
    //
    //        self.append(NSAttributedString(string: value, attributes:attributes))
    //        return self
    //    }
}

extension String {
    
    //To Decimal
    //2 -> 10
    func binToDec() -> Int {
        return createInt(radix: 2)
    }
    
    //8 -> 10
    func octToDec() -> Int {
        return createInt(radix: 8)
    }
    
    //16 -> 10
    func hexToDec() -> Int {
        return createInt(radix: 16)
    }
    
    //Others
    //2 -> 8
    func binToOct() -> String {
        return self.binToDec().decToOctString()
    }
    
    //2 -> 16
    func binToHex() -> String {
        return self.binToDec().decToHexString()
    }
    
    //8 -> 16
    func octToHex() -> String {
        return self.octToDec().decToHexString()
    }
    
    //16 -> 8
    func hexToOct() -> String {
        return self.hexToDec().decToOctString()
    }
    
    //16 -> 2
    func hexToBin() -> String {
        return self.hexToDec().decToBinString()
    }
    
    //8 -> 2
    func octToBin() -> String {
        return self.octToDec().decToBinString()
    }

    //Additional
    //16 -> 2
    func hexToBinStringFormat(minLength: Int = 0) -> String {
        
        return hexToBin().pad(minLength: minLength)
    }
    
    fileprivate func pad(minLength: Int) -> String {
        let padCount = minLength - self.count
        
        guard padCount > 0 else {
            return self
        }

        return String(repeating: "0", count: padCount) + self
    }

    fileprivate func createInt(radix: Int) -> Int {
        return Int(self, radix: radix)!
    }
    
}


extension Int {
    //From Decimal
        //10 -> 2
        func decToBinString() -> String {
            let result = createString(radix: 2)
            return result
        }
        
        //10 -> 8
        func decToOctString() -> String {
    //        let result = decToOctStringFormat()
            let result = createString(radix: 8)
            
            return result
        }
        
        //10 -> 16
        func decToHexString() -> String {
    //        let result = decToHexStringFormat()
            let result = createString(radix: 16)
            return result
        }
        
        //10 -> 8
        func decToOctStringFormat(minLength: Int = 0) -> String {

            return createString(minLength: minLength, system: "O")
        }

        //10 -> 16
        func decToHexStringFormat(minLength: Int = 0) -> String {

            return createString(minLength: minLength, system: "X")
        }
        
        fileprivate  func createString(radix: Int) -> String {
            return String(self, radix: radix, uppercase: true)
        }
        
        fileprivate func createString(minLength: Int = 0, system: String) -> String {
            //0 - fill empty space by 0
            //minLength - min count of chars
            //system - system number
            return String(format:"%0\(minLength)\(system)", self)
        }
}
