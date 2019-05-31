//
//  ShopProfileVC.swift
//  App
//
//  Created by Pqt Dark on 5/20/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import PKHUD
import CoreLocation

class ShopProfileVC: UIViewController {
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgCover: UIImageView!
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
    var idImgCoverUpload: String = ""
    var listCategory: [Category]?
    var category: Category?
    var isChangeAvata: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnLogout.layer.cornerRadius = 5.0
        btnLogout.layer.masksToBounds = true
        
        imgAvata.layer.cornerRadius = 40.0
        imgAvata.layer.borderWidth = 2.0
        imgAvata.layer.borderColor = UIColor(hexString: "#f2f3f4").cgColor
        imgAvata.layer.masksToBounds = true
        
        tfName.setRightPaddingPoints(40)
        tfAddress.setRightPaddingPoints(40)
        
        if let shopInfo: Shop = Common.shopInfo, shopInfo.id != "" {
            let phoneNumber = shopInfo.phone_contact ?? ((shopInfo.cc_contact ?? "").replacingOccurrences(of: "84", with: "0") + (shopInfo.contact ?? ""))
            tfPhone.text = phoneNumber
            tfName.text = shopInfo.name
            tfAddress.text = shopInfo.address
            tfCategory.text = shopInfo.category?.name
            imgAvata.kf.setImage(with: URL(string: shopInfo.avatar_url ?? ""),
                                     placeholder: UIImage(named: "ic_food"),
                                     completionHandler: { (image, _, _, _ ) in
                                        self.imgAvata.image = image })
            imgCover.kf.setImage(with: URL(string: shopInfo.cover_url ?? ""),
                                 placeholder: UIImage(named: "ic_food"),
                                 completionHandler: { (image, _, _, _ ) in
                                    self.imgCover.image = image })
        }
        else {
            FService.sharedInstance.getCategories { (categories, errMsg) in
                self.listCategory = categories
                self.btnChooseCategory.add(UIControl.Event.touchUpInside) { (act) in
                    self.performSegue(withIdentifier: "Category", sender: self)
                }
            }
            btnLogout.setTitle("Tạo thông tin", for: .normal)
        }
        
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
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
    
    @IBAction func editCover(_ sender: UIButton) {
        isChangeAvata = false
        self.showActionSheet(title: "Select a Photo",
                             message: nil,
                             alertActions:
            
            [UIAlertAction.init(title: "Cancel",
                                style: .cancel,
                                handler: { _ in }),
             
             UIAlertAction.init(title: "Take Photo",
                                style: .default,
                                handler: {   _ in
                                    
                                    self.openCamera(allowsEditing: true, animated: true, completion: { (_) in
                                        
                                    })
             }),
             
             UIAlertAction.init(title: "Choose from Library",
                                style: .default,
                                handler: {_ in
                                    
                                    self.openPhotoLibrary(allowsEditing: true, animated: true, completion: { (_) in
                                        
                                    })
             })]
        )
    }
    
    @IBAction func editAvata(_ sender: UIButton) {
        isChangeAvata = true
        self.showActionSheet(title: "Select a Photo",
                             message: nil,
                             alertActions:
            
            [UIAlertAction.init(title: "Cancel",
                                style: .cancel,
                                handler: { _ in }),
             
             UIAlertAction.init(title: "Take Photo",
                                style: .default,
                                handler: {   _ in
                                    
                                    self.openCamera(allowsEditing: true, animated: true, completion: { (_) in
                                        
                                    })
             }),
             
             UIAlertAction.init(title: "Choose from Library",
                                style: .default,
                                handler: {_ in
                                    
                                    self.openPhotoLibrary(allowsEditing: true, animated: true, completion: { (_) in
                                        
                                    })
             })]
        )
    }
    
    @IBAction func Logout(_ sender: Any) {
        
        if let shopInfo: Shop = Common.shopInfo, shopInfo.address != "" {
            Common.role = nil
            Common.token = nil
            Common.userInfo = nil
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.switchLoginViewController()
        }
        else {
            if tfName.text != "", tfAddress.text != "" {
                PKHUD.sharedHUD.show()
                
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(tfAddress.text ?? "") { (placemarks, error) in
                    let placemark = placemarks?.first
                    let lat = placemark?.location?.coordinate.latitude ?? 0.0
                    let long = placemark?.location?.coordinate.longitude ?? 0.0
                    //print("Lat: \(lat), Lon: \(lon)")
                    let pLocation = ["lat": lat, "lng": long]
                    FService.sharedInstance.createShopProfile(category_id: self.category?.id ?? "", avatar_id: self.idImgUpload, cover_id: self.idImgCoverUpload, name: self.tfName.text ?? "", address: self.tfAddress.text ?? "", location: pLocation as [String : Any]) { (success, errMsg) in
                        PKHUD.sharedHUD.hide()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Category" {
            let viewController: SelectCategoryVC = segue.destination as! SelectCategoryVC
            viewController.listCategory = self.listCategory
            viewController.selectCategoryBlock = { [weak self] (itemSelected) in
                guard let strongSelf = self else { return }
                strongSelf.tfCategory.text = itemSelected.name
                strongSelf.category = itemSelected
            }
        }
    }
}

extension ShopProfileVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if isChangeAvata == true {
            self.imgAvata.image = image
            if let shopInfo: Shop = Common.shopInfo, shopInfo.id != "" {
                
            }
            else {
                PKHUD.sharedHUD.show()
                FService.sharedInstance.uploadImage(url: FService.uploadImageUrl, image: image) { (ids, errMsg) in
                    self.idImgUpload = ids?.first ?? ""
                    PKHUD.sharedHUD.hide()
                }
            }
        }
        else {
            self.imgCover.image = image
            if let shopInfo: Shop = Common.shopInfo, shopInfo.id != "" {
                
            }
            else {
                PKHUD.sharedHUD.show()
                FService.sharedInstance.uploadImage(url: FService.uploadImageUrl, image: image) { (ids, errMsg) in
                    self.idImgCoverUpload = ids?.first ?? ""
                    PKHUD.sharedHUD.hide()
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ShopProfileVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let alert = UIAlertController(title: "Cập nhật thông tin", message: "Bạn muốn cập nhật lại thông tin?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            PKHUD.sharedHUD.show()
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(self.tfAddress.text ?? "") { (placemarks, error) in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude ?? 0.0
                let long = placemark?.location?.coordinate.longitude ?? 0.0
                //print("Lat: \(lat), Lon: \(lon)")
                let pLocation = ["lat": lat, "lng": long]
                FService.sharedInstance.saveNameShopProfile(name: self.tfName.text ?? "", address: self.tfAddress.text ?? "",location: pLocation) { (success, errMsg) in
                    PKHUD.sharedHUD.hide()
                }
            }
            
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { action in
            self.tfName.text = Common.shopInfo?.name
            self.tfAddress.text = Common.shopInfo?.address
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

