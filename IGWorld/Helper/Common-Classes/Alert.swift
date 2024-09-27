//
//  Alert.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit
import MBProgressHUD
import SystemConfiguration

protocol Utilities {
}

class Alert: NSObject,MBProgressHUDDelegate {
    
    // called method when show processing symbol
    class func showProgressHud(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
        DispatchQueue.main.async {
            if let view = sceneDelegate.window?.rootViewController?.view
            {
            let hud:MBProgressHUD = MBProgressHUD.showAdded(to: view, animated: true)
            hud.animationType = .fade
            hud.label.text = "Please wait...."
            hud.bezelView.color = AppColors.appSkyblue
        }
        }
}

    // called method when hide processing symbol
    class func hideProgressHud(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
        DispatchQueue.main.async {
            if let view = sceneDelegate.window?.rootViewController?.view
            {
            MBProgressHUD.hide(for: view, animated: true)
        }
        }
    }

    class func showAlert(_ msg:String,onView : UIView)
    {

        let progressHUD = MBProgressHUD.showAdded(to: onView, animated: true)
        progressHUD.mode = MBProgressHUDMode.text
        progressHUD.detailsLabel.text = msg
        progressHUD.detailsLabel.textColor = AppColors.heading_color
        progressHUD.detailsLabel.font = .systemFont(ofSize: 16.0)
        progressHUD.bezelView.color = AppColors.heading_color
        progressHUD.margin = 10.0
        progressHUD.offset.y = 150.0
        progressHUD.isUserInteractionEnabled = false
        progressHUD.removeFromSuperViewOnHide = true
        progressHUD.hide(animated: true, afterDelay: 3.0)
    }
    
    class func notReadyAlert(_ onView : UIViewController) {
        let alert = UIAlertController(title: LocalizedString.InDevelopment.localized, message: LocalizedString.componentIsnotReady.localized, preferredStyle: .alert)
        let action = UIAlertAction(title: LocalizedString.Ok.localized, style: .cancel, handler: nil)
        alert.view.tintColor = AppColors.heading_color
        alert.addAction(action)
        onView.present(alert, animated: true, completion: nil)
    }
    
    class func alert(message: String, title: String? = "",_ onView : UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.view.tintColor = AppColors.heading_color
            alert.view.overrideUserInterfaceStyle = .light
            let action = UIAlertAction(title: LocalizedString.Ok.localized, style: .cancel, handler: nil)
            alert.addAction(action)
            onView.present(alert, animated: true, completion: nil)
        }
    }
    
    //Show alert
    class func showAlertMsg(title: String, message: String,_ onView : UIViewController, complition: @escaping((_ finished: Bool) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = AppColors.heading_color
        alertController.view.overrideUserInterfaceStyle = .light
        onView.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alertController.dismiss(animated: true, completion: nil)
            complition(true)
        }
    }
    
    class func alert(message: String? = nil, title: String? = nil, titleImage: UIImage? = nil, buttons: [String], cancel: String? = nil, destructive: String? = nil, type: UIAlertController.Style = .alert,_ onView : UIViewController, handler :@escaping (Int) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: type)
            alert.view.tintColor = AppColors.heading_color
            alert.view.overrideUserInterfaceStyle = .light
            //Set Image with Title
            if titleImage != nil {
                //Create Attachment
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = titleImage
                let imageOffsetY: CGFloat = -15.0
                imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                
                let text = "\n" + (title ?? "")
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 0.7
                paragraphStyle.alignment = .center
                paragraphStyle.lineHeightMultiple = 1.4
                let attributes = [NSAttributedString.Key.foregroundColor: AppColors.babiesPink2, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.paragraphStyle: paragraphStyle]
                let titleImage = NSMutableAttributedString(string: text, attributes: attributes)
                completeText.append(titleImage)
                alert.setValue(completeText, forKey: "attributedTitle")
            }
            
            for button in buttons {
                let action = UIAlertAction(title: button, style: .default) { (action) in
                    if let index = buttons.firstIndex(of: action.title!) {
                        DispatchQueue.main.async {
                            handler(index)
                        }
                    }
                }
                alert.addAction(action)
                //                action.setValue(UIColor.themePinkColor, forKey: "titleTextColor")
            }
            
            if let destructiveText = destructive {
                let action = UIAlertAction(title: destructiveText, style: .destructive) { (_) in
                    handler(buttons.count)
                }
                alert.addAction(action)
                //                action.setValue(UIColor.themePinkColor, forKey: "titleTextColor")
            }
            
            if let cancelText = cancel {
                let action = UIAlertAction(title: cancelText, style: .cancel) { (_) in
                    let index = buttons.count + (destructive != nil ? 1 : 0)
                    handler(index)
                }
                alert.addAction(action)
                //                action.setValue(UIColor.themePinkColor, forKey: "titleTextColor")
            }
            
            onView.present(alert, animated: true, completion: nil)
        }
    }
}
