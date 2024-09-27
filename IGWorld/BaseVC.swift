//
//  BaseVC.swift
//  IGWorld
//
//  Created by ADITYA on 27/09/24.
//

import UIKit


class BaseVC: UIViewController {
    
    // MARK:- Variables
    // ==================
    var isStatusBarWhite = false {
        didSet{
            isStatusBarWhite ? makeStatusBarWhite() : makeStatusBarBlack()
        }
    }
    
    override public var shouldAutorotate: Bool {
       return false
     }
    
     override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
     }
    
     override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
       return .portrait
     }
    

    // MARK:- IBOutlets
    // ==================
    
    
    // MARK:- Life Cycle
    // ===================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isStatusBarWhite ? .lightContent : .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        self.isStatusBarWhite = false
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK:- Private Functions
// ==========================
extension BaseVC {
    /// Initial Setup
    private func initialSetup() {
        
    }
}

// MARK:- Functions
// ==================
extension BaseVC {
    /// Make Status Bar White
    private func makeStatusBarWhite() {
        setNeedsStatusBarAppearanceUpdate()
    }
    /// Make Status Bar Black
    private func makeStatusBarBlack() {
        setNeedsStatusBarAppearanceUpdate()
    }
}
