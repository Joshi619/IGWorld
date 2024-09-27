//
//  AppRouter.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit
import LGSideMenuController
import SwiftyJSON

enum AppRouter {


    /// Go To Home Screen
    static func goToHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }

        let mainViewController = HomeViewController.instantiate(fromAppStoryboard: .Main)

        let nvc = UINavigationController(rootViewController: mainViewController)
        nvc.isNavigationBarHidden = true
        
        sceneDelegate.window?.rootViewController =  mainViewController
        sceneDelegate.window?.becomeKey()
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    static func splashScreen() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }

        let mainViewController = SplashViewController.instantiate(fromAppStoryboard: .Main)

        let nvc = UINavigationController(rootViewController: mainViewController)
        nvc.isNavigationBarHidden = true
        UIView.transition(with: sceneDelegate.window!, duration: 0.33, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            sceneDelegate.window?.rootViewController =  nvc
        }, completion: { (finished) in
//            UIApplication.shared.registerForRemoteNotifications()
        })

        sceneDelegate.window?.becomeKey()
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    /// Setup First screen
    static func goToFirstScreen(_ isLaunchScreen: Bool,_ isLoginAniMation: Bool) {
        if isLaunchScreen {
            AppRouter.splashScreen()
        } else {
            AppRouter.goToHome()
        }
    }
}

struct AppUtility {

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
    
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

}
