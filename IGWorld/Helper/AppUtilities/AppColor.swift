//
//  AppColor.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit

enum AppColors {
    
    static var whiteColor: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
    static var babiesPink: UIColor { return #colorLiteral(red: 0.9529411765, green: 0.537254902, blue: 0.7254901961, alpha: 1) }
    static var babiesPink2: UIColor { return #colorLiteral(red: 0.9647058824, green: 0.6823529412, blue: 0.7019607843, alpha: 1) }
    static var appSkyblue: UIColor { return #colorLiteral(red: 0.2823529412, green: 0.7843137255, blue: 0.9607843137, alpha: 1) }
    static var Appblack_one:UIColor { return #colorLiteral(red: 0.4078431373, green: 0.4117647059, blue: 0.4, alpha: 1)}
    static var heading_color: UIColor { return #colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.01568627451, alpha: 1) }
    static var shadowBGcolor: UIColor { return #colorLiteral(red: 0.7098039216, green: 0.7098039216, blue: 0.7098039216, alpha: 1) }
    static var backgroundGray: UIColor { return #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1) }
    
    
}


extension UIColor {
    static var officialApplePlaceholderGray: UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
    
    class func colorFrom(hexString hexStr: String, alpha: CGFloat = 1) -> UIColor? {
        // 1. Make uppercase to reduce conditions
        var cStr = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased();
        
        // 2. Check if valid input
        let validRange = cStr.range(of: "\\b(0X|#)?([0-9A-F]{3,4}|[0-9A-F]{6}|[0-9A-F]{8})\\b", options: NSString.CompareOptions.regularExpression)
        if validRange == nil {
            print("Error: Inavlid format string: \(hexStr). Check documantation for correct formats", terminator: "")
            return nil
        }
        
        cStr = cStr.substring(with: validRange!)
        
        if(cStr.hasPrefix("0X")) {
            cStr = cStr.substring(from: cStr.index(cStr.startIndex, offsetBy: 2))
        } else if(cStr.hasPrefix("#")) {
            cStr = cStr.substring(from: cStr.index(cStr.startIndex, offsetBy: 1))
        }
        
        let strLen = cStr.count
        if (strLen == 3 || strLen == 4) {
            // Make it double
            var str2 = ""
            for ch in cStr {
                str2 += "\(ch)\(ch)"
            }
            cStr = str2
        } else if (strLen == 6 || strLen == 8) {
            // Do nothing
        } else {
            return nil
        }
        
        let scanner = Scanner(string: cStr)
        var hexValue: UInt32 = 0
        if scanner.scanHexInt32(&hexValue) {
            if cStr.count == 8 {
                let hex8: UInt32 = hexValue
                let divisor = CGFloat(255)
                let red     = CGFloat((hex8 & 0xFF000000) >> 24) / divisor
                let green   = CGFloat((hex8 & 0x00FF0000) >> 16) / divisor
                let blue    = CGFloat((hex8 & 0x0000FF00) >>  8) / divisor
                let alpha   = CGFloat( hex8 & 0x000000FF       ) / divisor
                return UIColor(red: red, green: green, blue: blue, alpha: alpha)            }
            else {
                let hex6: UInt32 = hexValue
                let divisor = CGFloat(255)
                let red     = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
                let green   = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
                let blue    = CGFloat( hex6 & 0x0000FF       ) / divisor
                return UIColor(red: red, green: green, blue: blue, alpha: alpha)
            }
        } else {
            print("scan hex error")
        }
        
        return nil
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
    
    var hexString: String {
        var R: CGFloat = 0
        var G: CGFloat = 0
        var B: CGFloat = 0
        var A: CGFloat = 0
        
        getRed(&R, green: &G, blue: &B, alpha: &A)
        
        let RGB = Int(Int((R * 255)) << 16) | Int(Int((G * 255)) << 8) | Int(Int((B * 255)) << 0)
        let hex = String(format: "#%06x", arguments: [RGB])
        
        return hex
    }
}

