//
//  CurrentOrderVCViewController.swift
//  App
//
//  Created by Pqt Dark on 6/8/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class CurrentOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var midleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbAddress1: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbAddress2: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbNameShop: UILabel!
    @IBOutlet weak var lbPhoneShop: UILabel!
    
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbSubTotal: UILabel!
    @IBOutlet weak var lbFeeShipping: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var heightBtn: NSLayoutConstraint!
    
    var listPost: [Post]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        headerView.layer.cornerRadius = 5.0
        headerView.layer.masksToBounds = true
        midleView.layer.cornerRadius = 5.0
        midleView.layer.masksToBounds = true
        statusView.layer.cornerRadius = 5.0
        statusView.layer.masksToBounds = true
        btnCancel.layer.cornerRadius = 5.0
        btnCancel.layer.masksToBounds = true
        
        self.tableView.tableFooterView = UIView()
    }
    
    func setDataInfo(currentOrder: CurrentOrder?) {
        lbAddress1.text = currentOrder?.address
        lbDistance.text = String(format: "%.2f km", (currentOrder?.distance ?? 0.0)/1000)
        lbAddress2.text = currentOrder?.shop?.address
        lbStatus.text = currentOrder?.status
        lbNameShop.text = currentOrder?.shop?.name
        let phoneNumber = currentOrder?.shop?.phone_contact ?? ((currentOrder?.shop?.cc_contact ?? "--").replacingOccurrences(of: "84", with: "0") + (currentOrder?.shop?.contact ?? "--"))
        lbPhoneShop.text = phoneNumber
        lbSubTotal.text = currentOrder?.subtotal?._vnCurrencyString
        lbFeeShipping.text = currentOrder?.fee_amount?._vnCurrencyString
        lbTotalPrice.text = currentOrder?.total?._vnCurrencyString
        self.listPost = currentOrder?.details
        self.tableView.reloadData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listPost?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        if let cell: ItemTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as? ItemTableViewCell {
            cell.selectionStyle = .none
            if let post: Post = self.listPost?[indexPath.row] {
                cell.lbName.text = post.post_name
                cell.lbPrice.text = (post.price?._vnCurrencyString ?? "0.0")
                cell.lbQuaity.text = "x " + "\(post.quantity ?? 0)"
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

}
