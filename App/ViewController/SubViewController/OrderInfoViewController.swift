//
//  OrderInfoViewController.swift
//  App
//
//  Created by Pqt Dark on 5/9/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import PKHUD

class OrderInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbShopName: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbFeeShip: UILabel!
    @IBOutlet weak var lbShopAddress: UILabel!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var btnCreateOrder: UIButton!
    
    var shopInfo: Shop?
    var listPost: [Post]?
    var feeShip: Double = 0.0
    var currentDistance: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40
        tableView.tableFooterView = UIView()
        
        btnCreateOrder.layer.cornerRadius = 5.0
        btnCreateOrder.layer.masksToBounds = true
        
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        
        self.lbAddress.text = Common.curentLocation?.address
        self.lbShopName.text = shopInfo?.name
        self.lbShopAddress.text = shopInfo?.address
        let strDistance = String(format: "%.2f km", currentDistance/1000)
        self.lbDistance.text = "Khoảng cách: \(strDistance)"
        
        if currentDistance/1000 <= 2.0 {
            feeShip = 20000
        }
        else if currentDistance/1000 <= 5.0 {
            feeShip = 50000
        }
        else {
            feeShip = 10000 * currentDistance/1000
        }
        self.lbFeeShip.text = feeShip._vnCurrencyString
        
        var sumPrice = 0.0
        for post in self.listPost ?? [] {
            sumPrice += (post.price ?? 0.0) * Double(post.numSelected)
        }
        let totalPrice = sumPrice + feeShip
        self.lbTotalPrice.text = totalPrice._vnCurrencyString
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
                cell.lbName.text = post.name
                cell.lbPrice.text = (post.price?._vnCurrencyString ?? "0.0")
                cell.lbQuaity.text = " x " + "\(post.numSelected)"
            }
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAction(_ sender: Any) {
        PKHUD.sharedHUD.show()
        FService.sharedInstance.createOrder(shop_id: self.shopInfo?.id ?? "", distance: self.currentDistance, posts: self.listPost ?? []) { (id, errMsg) in
            PKHUD.sharedHUD.hide()
            let alert = UIAlertController(title: "Tạo đơn hàng thành công", message: "Quay về màn hình chính để theo dõi đơn hàng!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
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
