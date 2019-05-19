//
//  LoginViewController.swift
//  App
//
//  Created by Pqt Dark on 4/20/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import AccountKit

class LoginViewController: UIViewController, AKFViewControllerDelegate {

    @IBOutlet weak var vRoleUser: UIView!
    @IBOutlet weak var vRoleShipper: UIView!
    @IBOutlet weak var vRoleShop: UIView!
    
    var _accountKit: AKFAccountKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vRoleUser.applyCornerRadiusDefault()
        vRoleShipper.applyCornerRadiusDefault()
        vRoleShop.applyCornerRadiusDefault()
        
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .accessToken)
        }
    }
    
    func loginWithPhone(){
        let inputState = UUID().uuidString
        let vc = (_accountKit?.viewControllerForPhoneLogin(with: nil, state: inputState))!
        vc.enableSendToFacebook = true
        self.prepareLoginViewController(loginViewController: vc)
        self.present(vc as UIViewController, animated: true, completion: nil)
    }
    
    func prepareLoginViewController(loginViewController: AKFViewController) {
        loginViewController.delegate = self
        //UI Theming - Optional
        loginViewController.defaultCountryCode = "VN"
        loginViewController.whitelistedCountryCodes = ["VN"]
        loginViewController.uiManager = AKFSkinManager(skinType: .classic, primaryColor: .lightGray)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("did complete login with access token \(accessToken.tokenString) state \(state ?? "abc")")
        // switch root view controllers in AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchMainViewControllers()
    }

    @IBAction func userLogin(_ sender: Any) {
        self.loginWithPhone()
    }
    @IBAction func shipperLogin(_ sender: Any) {
        self.loginWithPhone()
    }
    @IBAction func shopLogin(_ sender: Any) {
        self.loginWithPhone()
    }
}
