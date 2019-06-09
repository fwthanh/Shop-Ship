//
//  SelectMenuVC.swift
//  App
//
//  Created by Pqt Dark on 5/8/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class SelectMenuVC: UIViewController {

    @IBOutlet weak var btnLess: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbNumber: UILabel!
    @IBOutlet weak var lbMoney: UILabel!
    
    var postInfo: Post?
    var countSelected: Int = 0
    var moneySelected: Double = 0
    var dismissDialogBlock: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnLess.layer.cornerRadius = 5.0
        btnLess.layer.borderWidth = 1.0
        btnLess.layer.borderColor = UIColor.lightGray.cgColor
        btnLess.layer.masksToBounds = true
        
        btnMore.layer.cornerRadius = 5.0
        btnMore.layer.borderWidth = 1.0
        btnMore.layer.borderColor = UIColor.lightGray.cgColor
        btnMore.layer.masksToBounds = true
        
        btnCancel.layer.cornerRadius = 5.0
        btnCancel.layer.borderWidth = 1.0
        btnCancel.layer.borderColor = UIColor.lightGray.cgColor
        btnCancel.layer.masksToBounds = true
        
        countSelected = postInfo?.numSelected ?? 0
        
        self.btnLess.isEnabled = countSelected > 0
        self.lbTitle.text = postInfo?.name
        self.lbDescription.text = postInfo?.desc
        self.lbNumber.text = "\(countSelected)"
        self.moneySelected = postInfo?.price ?? 0.0
        self.lbMoney.text = self.moneySelected._vnCurrencyString
    }
    
    @IBAction func dismissDialog(_ sender: UIButton) {
        self.dismissDialogBlock?(sender.tag == 1 ? countSelected : -1)
    }
    
    @IBAction func moreItem(_ sender: UIButton) {
        countSelected += 1
        lbNumber.text = "\(countSelected)"
        let money: Double = self.moneySelected * Double(countSelected)
        self.lbMoney.text = money._vnCurrencyString
        if countSelected > 0 {
            self.btnLess.isEnabled = true
        }
    }
    
    @IBAction func lessItem(_ sender: UIButton) {
        countSelected -= 1
        lbNumber.text = "\(countSelected)"
        let money: Double = self.moneySelected * Double(countSelected)
        self.lbMoney.text = money._vnCurrencyString
        if countSelected == 0 {
            self.btnLess.isEnabled = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
