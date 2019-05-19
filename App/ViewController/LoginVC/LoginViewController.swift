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
    var selectRole: String = "user"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vRoleUser.applyCornerRadiusDefault()
        vRoleShipper.applyCornerRadiusDefault()
        vRoleShop.applyCornerRadiusDefault()
        
        if _accountKit == nil {
            _accountKit = AKFAccountKit(responseType: .authorizationCode)
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

    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        FService.sharedInstance.login(code: code, role: selectRole) { (token, errMsg) in
            if token != nil {
                Common.token = token
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.switchMainViewControllers()
            }
            else {
                let alert = UIAlertController(title: errMsg, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func userLogin(_ sender: Any) {
        selectRole = "user"
        self.loginWithPhone()
    }
    @IBAction func shipperLogin(_ sender: Any) {
        selectRole = "shipper"
        self.loginWithPhone()
    }
    @IBAction func shopLogin(_ sender: Any) {
        selectRole = "shop"
        self.loginWithPhone()
    }
}
