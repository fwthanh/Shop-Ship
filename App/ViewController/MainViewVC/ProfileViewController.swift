//
//  ProfileViewController.swift
//  App
//
//  Created by Pqt Dark on 5/4/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnEditName: UIButton!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var btnEditAvata: UIButton!
    
    var isEditingName: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnLogout.layer.cornerRadius = 5.0
        btnLogout.layer.masksToBounds = true
        
        imgAvata.layer.cornerRadius = 40.0
        imgAvata.layer.masksToBounds = true
    }
    
    @IBAction func editName(_ sender: UIButton) {
        btnEditName.isSelected = !btnEditName.isSelected
        if btnEditName.isSelected == true {
            tfName.isEnabled = true
            tfName.becomeFirstResponder()
        }
        else {
            tfName.isEnabled = false
            tfName.resignFirstResponder()
        }
    }
    
    @IBAction func editAvata(_ sender: UIButton) {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Approve", style: .default , handler:{ (UIAlertAction)in
            print("User click Approve button")
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
            print("User click Edit button")
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
            print("User click Delete button")
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    @IBAction func Logout(_ sender: Any) {
        
    }
}
