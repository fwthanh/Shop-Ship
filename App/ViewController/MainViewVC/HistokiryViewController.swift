//
//  HistokiryViewController.swift
//  App
//
//  Created by Pqt Dark on 4/15/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class HistokiryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var listHistory: [CurrentOrder]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        
        FService.sharedInstance.getUserHistory { (histories, errMsg) in
            self.listHistory = histories
            self.tableView.reloadData()
        }
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.listHistory?.count ?? 0) == 0 ? 1 : (self.listHistory?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        if (self.listHistory?.count ?? 0) > 0, let order: CurrentOrder = self.listHistory?[indexPath.row] {
            if let cell: TblHistoryCell = self.tableView.dequeueReusableCell(withIdentifier: "TblHistoryCell") as? TblHistoryCell {
                cell.selectionStyle = .none
                cell.lbStatus.text = order.status
                cell.lbDate.text = ""
                cell.lbAddress2.text = order.address
                cell.lbAddress1.text = order.shop?.address
                cell.lbOrderCode.text = "Đơn hàng: \(order.id ?? "")"
                cell.lbTotalPrice.text = "Tổng tiền thanh toán: \(order.total?._vnCurrencyString ?? "0.0")"
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
        else {
            if let cell: EmptyTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell") as? EmptyTableViewCell {
                cell.selectionStyle = .none
                return cell
            }
            else {
                return UITableViewCell()
            }
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}

