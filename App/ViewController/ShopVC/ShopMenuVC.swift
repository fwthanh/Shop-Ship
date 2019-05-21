//
//  ShopMenuVC.swift
//  App
//
//  Created by Pqt Dark on 5/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class ShopMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        
        FService.sharedInstance.getShopProfile { (shop, errMsg) in
            if shop == nil && errMsg == nil {
                let alert = UIAlertController(title: "Cập nhật thông tin", message: "Vui lòng cập nhật thông tin của bạn!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.tabBarController?.selectedIndex = 2
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        if let cell: MenuTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as? MenuTableViewCell {
            cell.selectionStyle = .none
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

}
