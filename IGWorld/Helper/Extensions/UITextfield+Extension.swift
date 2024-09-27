//
//  UITextfield+Extension.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit

extension UITextField {

    func replacingCaracter(in range: NSRange, with replacement: String) -> String {
        return (self.text! as NSString).replacingCharacters(in: range, with: replacement)
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setLeftIcon(_ image: UIImage, width: CGFloat = 23, height: CGFloat = 23) {
       let iconView = UIImageView(frame:
                      CGRect(x: 0, y: 0, width: width, height: height))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 30, y: 0, width: width, height: height))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    func setRightIcon(_ image: UIImage, width: CGFloat = 23, height: CGFloat = 23) {
       let iconView = UIImageView(frame:
                      CGRect(x: 0, y: 0, width: width, height: height))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 0, y: 0, width: width, height: height))
       iconContainerView.addSubview(iconView)
       rightView = iconContainerView
       rightViewMode = .always
    }
}


extension UITextView {

    func setPadddings (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat){
        self.textContainerInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)

    }
}

@IBDesignable
class DesignableUITextField: UITextField {

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }

    }

    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0

    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }

    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }

        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}


