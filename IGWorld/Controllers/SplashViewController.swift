//
//  SplashViewController.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit
import SDWebImage

class SplashViewController: BaseVC {
    @IBOutlet weak var logoImageview: SDAnimatedImageView!
    @IBOutlet weak var imageVerticalConstraint: NSLayoutConstraint! //50
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageview.image = SDAnimatedImage(named: "SplashIcon.gif")
        logoImageview.animationRepeatCount = 1
        logoImageview.shouldCustomLoopCount = true
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIView.AnimationOptions.allowAnimatedContent,
                   animations: { () -> Void in
//            while self.titleImageTopConstraint.constant > 20 {
//                self.titleImageTopConstraint.constant -= 1
//                self.view.layoutIfNeeded()
//            }
           
        }, completion: { (finished) -> Void in
        // ....
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            AppRouter.goToFirstScreen(false, true)
        }
    }

}
