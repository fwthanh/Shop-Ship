//
//  ShopProfileVC.swift
//  App
//
//  Created by Pqt Dark on 5/20/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class ShopProfileVC: UIViewController {
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnEditName: UIButton!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var btnEditAddress: UIButton!
    @IBOutlet weak var tfCategory: UITextField!
    @IBOutlet weak var btnChooseCategory: UIButton!
    @IBOutlet weak var btnEditAvata: UIButton!
    
    var isEditingName: Bool = false
    var idImgUpload: String = ""
    var listCategory: [Category]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnLogout.layer.cornerRadius = 5.0
        btnLogout.layer.masksToBounds = true
        
        imgAvata.layer.cornerRadius = 40.0
        imgAvata.layer.masksToBounds = true
        
        if let shopInfo: Shop = Common.shopInfo, shopInfo.address != "" {
            tfPhone.text = shopInfo.phone_contact?.replacingOccurrences(of: "84", with: "0")
        }
        else {
            FService.sharedInstance.getCategories { (categories, errMsg) in
                self.listCategory = categories
            }
            self.btnChooseCategory.add(UIControl.Event.touchUpInside) { (act) in
                self.performSegue(withIdentifier: "Category", sender: self)
            }
        }
        
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
    
    @IBAction func editAddress(_ sender: UIButton) {
        btnEditAddress.isSelected = !btnEditAddress.isSelected
        if btnEditAddress.isSelected == true {
            tfAddress.isEnabled = true
            tfAddress.becomeFirstResponder()
        }
        else {
            tfAddress.isEnabled = false
            tfAddress.resignFirstResponder()
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
        FService.sharedInstance.uploadImage(url: FService.uploadImageUrl, image: UIImage(named: "ic_delivery")!) { (ids, errMsg) in
            self.idImgUpload = ids?.first ?? ""
            if self.idImgUpload != "" {
                
            }
        }
//        Common.role = nil
//        Common.token = nil
//        Common.userInfo = nil
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.switchLoginViewController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Category" {
            let viewController: SelectCategoryVC = segue.destination as! SelectCategoryVC
            //viewController.idShop = 1
        }
    }
}
