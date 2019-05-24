//
//  CreateMenuVC.swift
//  App
//
//  Created by Pqt Dark on 5/24/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import PKHUD

class CreateMenuVC: UIViewController {

    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDescription: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfAmount: UITextField!
    @IBOutlet weak var tfDiscount: UITextField!
    @IBOutlet weak var btnDiscount: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    var postInfo: Post?
    var idImgUpload: String = ""
    var addPostBlock: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        self.hideKeyboardWhenTappedAround()
        
        imgAvata.layer.cornerRadius = 5.0
        imgAvata.layer.masksToBounds = true
        
        btnCreate.layer.cornerRadius = 5.0
        btnCreate.layer.masksToBounds = true
        
        btnDiscount.layer.cornerRadius = 5.0
        btnDiscount.layer.masksToBounds = true
        btnDiscount.layer.borderWidth = 1.0
        btnDiscount.layer.borderColor = UIColor(hexString: "#EAEAEA").cgColor
        
        if postInfo != nil {
            self.imgAvata.kf.setImage(with: URL(string: postInfo?.avatar_url ?? ""),
                                      placeholder: UIImage(named: "ic_food"),
                                      completionHandler: { (image, _, _, _ ) in
                                        self.imgAvata.image = image })
            self.tfName.text = postInfo?.name
            self.tfDescription.text = postInfo?.desc
            self.tfPrice.text = "\(Int(postInfo?.price ?? 0))"
            self.tfDiscount.text = "\(Int(postInfo?.promo_price ?? 0))"
            self.tfAmount.text = "\(postInfo?.quantity ?? 0)"
            
            self.btnCreate.setTitle("Cập nhật thông tin", for: .normal)
        }
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        let discount = ["type": "percent", "value": 20] as [String : Any]
        let stPrice = tfPrice.text ?? "0"
        let price: CGFloat = NumberFormatter().number(from: stPrice) as? CGFloat ?? 0.0
        FService.sharedInstance.createPost(name: tfName.text ?? "", description: tfDescription.text ?? "", quantity: Int(tfAmount.text ?? "0") ?? 0, price: price, discount: discount, avatar_id: self.idImgUpload) { (success, errMsg) in
            if success != nil {
                self.addPostBlock?("success")
                self.navigationController?.popViewController(animated: true)
            }
            else {
                let alert = UIAlertController(title: errMsg, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func discountAction(_ sender: UIButton) {
        
    }
    
    @IBAction func avataAction(_ sender: UIButton) {
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
}

extension CreateMenuVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.imgAvata.image = image
        PKHUD.sharedHUD.show()
        FService.sharedInstance.uploadImage(url: FService.uploadImageUrl, image: image) { (ids, errMsg) in
            self.idImgUpload = ids?.first ?? ""
            PKHUD.sharedHUD.hide()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
