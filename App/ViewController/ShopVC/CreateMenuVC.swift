//
//  CreateMenuVC.swift
//  App
//
//  Created by Pqt Dark on 5/24/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import PKHUD
import SwiftValidator

class CreateMenuVC: UIViewController, ValidationDelegate {

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
    var currentString: String = ""
    var discountType: String = "percent"
    let validator = Validator()
    
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
            self.discountType = postInfo?.discount?.type ?? "percent"
            self.imgAvata.kf.setImage(with: URL(string: postInfo?.avatar_url ?? ""),
                                      placeholder: UIImage(named: "ic_food"),
                                      completionHandler: { (image, _, _, _ ) in
                                        self.imgAvata.image = image })
            self.tfName.text = postInfo?.name
            self.tfDescription.text = postInfo?.desc
            self.tfPrice.text = postInfo?.price?._vnCurrencyString
            self.tfDiscount.text = postInfo?.discount?.type == "fixed" ? postInfo?.discount?.value?._vnCurrencyString : "\(Int(postInfo?.discount?.value ?? 0))"
            self.tfAmount.text = "\(postInfo?.quantity ?? 0)"
            self.btnDiscount.setTitle(postInfo?.discount?.type == "percent" ? "%" : "đ", for: .normal)
            self.btnCreate.setTitle("Cập nhật thông tin", for: .normal)
        }
        
        validator.styleTransformers(success:{
            (validationRule) -> Void in
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.layer.borderWidth = 0.0
            } else if let textField = validationRule.field as? UITextView {
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.layer.borderWidth = 0.0
            }
        }, error:{
            (validationError) -> Void in
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            } else if let textField = validationError.field as? UITextView {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        //validator.registerField(tfName, errorLabel: nil, rules: [RequiredRule(message: "Vui lòng nhập tên sản phẩm!"), EmailRule(message: "Email không đúng định dạng")])
        validator.registerField(tfAmount, errorLabel: nil, rules: [RequiredRule(message: "Vui lòng nhập số lượng sản phẩm!")])
        validator.registerField(tfPrice, errorLabel: nil, rules: [RequiredRule(message: "Vui lòng nhập giá sản phẩm!")])
        validator.registerField(tfName, errorLabel: nil, rules: [RequiredRule(message: "Vui lòng nhập tên sản phẩm!")])
    }
    
    // ValidationDelegate methods
    func validationSuccessful() {
        // submit the form
        if postInfo != nil {
            let valueDiscount = self.discountType == "fixed" ? tfDiscount.text?._currencyDouble : Double(tfDiscount.text ?? "0")!
            let discount = ["type": discountType, "value": valueDiscount!] as [String : Any]
            let stPrice = tfPrice.text ?? "0"
            let price = stPrice._currencyDouble
            FService.sharedInstance.editPost(idPost: postInfo?.id ?? "", name: tfName.text ?? "", description: tfDescription.text ?? "", quantity: Int(tfAmount.text ?? "0") ?? 0, price: price, discount: discount, avatar_id: self.idImgUpload) { (success, errMsg) in
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
        else {
            let discount = ["type": "percent", "value": 20] as [String : Any]
            let stPrice = tfPrice.text ?? "0"
            let price = stPrice._currencyDouble
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
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        validator.validate(self)
    }
    
    @IBAction func discountAction(_ sender: UIButton) {
        self.showActionSheet(title: "Chọn loại khuyến mãi",
                             message: nil,
                             alertActions:
            
            [UIAlertAction.init(title: "Cancel",
                                style: .cancel,
                                handler: { _ in }),
             
             UIAlertAction.init(title: "Theo giá",
                                style: .default,
                                handler: {   _ in
                                    self.discountType = "fixed"
                                    self.tfDiscount.text = "0"
                                    self.btnDiscount.setTitle("đ", for: .normal)
             }),
             
             UIAlertAction.init(title: "Theo phần trăm",
                                style: .default,
                                handler: {_ in
                                    self.discountType = "percent"
                                    self.tfDiscount.text = "0"
                                    self.btnDiscount.setTitle("%", for: .normal)
             })]
        )
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

extension CreateMenuVC: UITextFieldDelegate {
    
    //Textfield delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        if textField == tfPrice || (textField == tfDiscount && self.discountType == "fixed") {
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                currentString += string
                textField.text = formatCurrency(string: currentString)
            default:
                let array = Array(string)
                var currentStringArray = Array(currentString)
                if array.count == 0 && currentStringArray.count != 0 {
                    currentStringArray.removeLast()
                    currentString = ""
                    for character in currentStringArray {
                        currentString += String(character)
                    }
                    textField.text = formatCurrency(string: currentString)
                }
            }
            return false
        }
        else {
            return true
        }
    }
    
    func formatCurrency(string: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.locale = NSLocale(localeIdentifier: "vi_VN") as Locale
        let numberFromField = (NSString(string: currentString).doubleValue)
        return formatter.string(from: NSNumber(value: numberFromField)) ?? ""
    }
}
