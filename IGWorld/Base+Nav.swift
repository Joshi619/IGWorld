//
//  Base+Nav.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {

    // MARK:- LifeCycle
    // ==================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = false
    }

    override var prefersStatusBarHidden: Bool {
        return (self.topViewController?.prefersStatusBarHidden)!
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    //MARK: - UINavigationControllerDelegate Methods

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //self.interactivePopGestureRecognizer?.isEnabled = true
        self.interactivePopGestureRecognizer?.isEnabled = false
        super.pushViewController(viewController, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        //Write any custom functionality if required in future
    }

}
