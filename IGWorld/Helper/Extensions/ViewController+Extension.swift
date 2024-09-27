//
//  ViewController+Extension.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit

extension UIViewController {

    ///Not using static as it won't be possible to override to provide custom storyboardID then
    class var storyboardID : String {

        return "\(self)"
    }

    func getTabBarHeight() -> CGFloat {

        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return 65 + (window?.safeAreaInsets.bottom ?? CGFloat.zero)
    }

}
