//
//  ProfileViewController.swift
//  App
//
//  Created by Pqt Dark on 5/4/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import PKHUD
import CoreLocation

class ProfileViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var btnEditAvata: UIButton!
    
    var isEditingName: Bool = false
    var idImgUpload: String = ""
    var idImgCoverUpload: String = ""
    var isChangeAvata: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnLogout.layer.cornerRadius = 5.0
        btnLogout.layer.masksToBounds = true
        
        imgAvata.layer.cornerRadius = 50.0
        imgAvata.layer.borderWidth = 2.0
        imgAvata.layer.borderColor = UIColor(hexString: "#f2f3f4").cgColor
        imgAvata.layer.masksToBounds = true
        
        if let userInfo: User = Common.userInfo {
            self.setUserInfo(user: userInfo)
        }
        else {
            FService.sharedInstance.getUserProfile { (user, errMsg) in
                Common.userInfo = user
                self.setUserInfo(user: user)
            }
        }
        
        self.hideKeyboardWhenTappedAround()
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
    }
    
    func setUserInfo(user: User?) {
        self.tfPhone.text = user?.phone_contact?.replacingOccurrences(of: "84", with: "0")
        self.tfName.text = user?.name
        self.lbName.text = user?.name
        self.imgAvata.kf.setImage(with: URL(string: user?.avatar_url ?? ""), placeholder: UIImage(named: "img_placeholder"), completionHandler: { (image, _, _, _ ) in
            self.imgAvata.image = image ?? UIImage(named: "img_placeholder")
        })
        self.imgCover.kf.setImage(with: URL(string: user?.cover_url ?? ""), placeholder: UIImage(named: "img_placeholder"), completionHandler: { (image, _, _, _ ) in
            self.imgCover.image = image ?? UIImage(named: "img_placeholder")
        })
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
        Common.role = nil
        Common.token = nil
        Common.userInfo = nil
        Common.curentLocation = nil
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchLoginViewController()
    }
}

extension ProfileViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if isChangeAvata == true {
            self.imgAvata.image = image
            PKHUD.sharedHUD.show()
            FService.sharedInstance.uploadImage(url: FService.uploadImageUrl, image: image) { (ids, errMsg) in
                self.idImgUpload = ids?.first ?? ""
                let user = Common.userInfo
                let pLocation = ["lat": Common.curentLocation?.lat ?? 00, "lng": Common.curentLocation?.lng ?? 0.0]
                FService.sharedInstance.saveUserProfile(avatar_id: self.idImgUpload, cover_id: "", name: user?.name ?? " ", address: " ", location: pLocation, completion: { (success, errMsg) in
                    PKHUD.sharedHUD.hide()
                })
            }
        }
        else {
            self.imgCover.image = image
            PKHUD.sharedHUD.show()
            FService.sharedInstance.uploadImage(url: FService.uploadImageUrl, image: image) { (ids, errMsg) in
                self.idImgCoverUpload = ids?.first ?? ""
                let user = Common.userInfo
                let pLocation = ["lat": Common.curentLocation?.lat ?? 00, "lng": Common.curentLocation?.lng ?? 0.0]
                FService.sharedInstance.saveUserProfile(avatar_id: "", cover_id: self.idImgCoverUpload, name: user?.name ?? " ", address: " ", location: pLocation, completion: { (success, errMsg) in
                    PKHUD.sharedHUD.hide()
                })
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let pLocation = ["lat": Common.curentLocation?.lat ?? 00, "lng": Common.curentLocation?.lng ?? 0.0]
        FService.sharedInstance.saveUserProfile(avatar_id: "", cover_id: "", name: textField.text ?? " ", address: " ", location: pLocation) { (success, errMsg) in
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
