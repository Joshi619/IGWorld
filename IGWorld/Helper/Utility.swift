//
//  Utility.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit

class Utility {
    
    static func setBoolInUserDefaultData(value: Bool = false, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    
    static func createAndWriteFile(name: String, data: Data,subfolder: String? = nil) -> URL? {
       let documentDirectoryUrl = try! FileManager.default.url(
          for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
       )
        var fileurl: URL?
        if subfolder == nil {
            fileurl = documentDirectoryUrl.appendingPathComponent(name)//.appendingPathComponent(AppConstant.appName).appendingPathComponent(name)
        } else {
            fileurl = documentDirectoryUrl.appendingPathComponent(name)//appendingPathComponent(AppConstant.appName).appendingPathComponent(subfolder ?? "").appendingPathComponent(name)
        }
       // prints the file path
        print("File path \(fileurl?.path ?? "")")
       //data to write in file.
        guard let url = fileurl else { return nil}
       do {
           try data.write(to: url, options: .atomic)
       } catch let error as NSError {
          print (error)
       }
        return url
    }
    
    static func retriveBooleanFromUserDefault(key: String) -> Bool {
        return  UserDefaults.standard.bool(forKey: key)
    }
    
    static func setStringObject(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func retriveStringObject(key: String) -> String {
        
        return  UserDefaults.standard.string(forKey: key) ?? ""
    }
    //
    
    static func getDateFromTimeStamp(_ timeStamp : TimeInterval) -> String? {
        
        let date = NSDate(timeIntervalSince1970: timeStamp)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        dayTimePeriodFormatter.locale = Locale(identifier: "en_US_POSIX")
        dayTimePeriodFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        let fullNameArr = dateString.components(separatedBy: ":")
        guard let hour = Int(fullNameArr[0]) else {return nil}
        let minA = fullNameArr[1].components(separatedBy: " ")
        guard let min = Int(minA[0]) else {return nil}
        let hrs = String(minA[1])
        return "\(hour):\((min > 29) ? 30:00) \(hrs)"
        //  return TimeInterval((hour * 60 * 60) + (min * 60))
    }
    
    
    static func getDateFromTimeStampByFormat(from interval : TimeInterval, _ format:String = "hh:mm a") -> String?
    {
        let date = NSDate(timeIntervalSince1970: interval)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        dayTimePeriodFormatter.locale = Calendar.current.locale//Locale(identifier: "en_US_POSIX")
        dayTimePeriodFormatter.timeZone = Calendar.current.timeZone//TimeZone(abbreviation: "UTC")
        return dayTimePeriodFormatter.string(from: date as Date)
    }

    static func getCurrentDateTime() -> String
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let current_date = dateFormatter.string(from: date)
        return current_date
    }

    static func convertDateFormat(_ inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        guard let oldDate = olDateFormatter.date(from: inputDate) else { return "" }

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "dd/MM/yyyy"

         return convertDateFormatter.string(from: oldDate)
    }

    static func cropImage(image: UIImage, toRect: CGRect) -> UIImage? {
        // Cropping is available trhough CGGraphics
        let cgImage :CGImage! = image.cgImage
        let croppedCGImage: CGImage! = cgImage.cropping(to: toRect)

        return UIImage(cgImage: croppedCGImage)
    }
    
    static func changeLanguage(language:Language){
        Bundle.set(language:language)
        AppConstant.selectedLanguage = language
        AppUserDefaults.save(value: language.code, forKey: .language)
    }
    
    func setLanguageOfApp(){
        if AppUserDefaults.value(forKey: .language).stringValue != nil {
            let code = AppUserDefaults.value(forKey: .language).stringValue
            switch code {
            case "en":
                Utility.changeLanguage(language:.english(.us))
                break
            case "ja":
                Utility.changeLanguage(language:.japanese)
                break
            case "zh-Hans":
                Utility.changeLanguage(language:.chinese)
                break
            default:
                Utility.changeLanguage(language:.english(.us))
            }
        }else {
            AppConstant.selectedLanguage = .english(.us)
        }
    }
}

