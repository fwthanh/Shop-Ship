//
//  FirstViewController.swift
//  App
//
//  Created by Pqt Dark on 4/15/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // (optional) include this line if you want to remove the extra empty cell divider lines
        self.tableView.tableFooterView = UIView()
    }

    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        }
        else if indexPath.row == 1 {
            return (self.view.bounds.width/4 - 16) * 3 + 40
        }
        return (80 * 8) + 40
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        if indexPath.row == 0, let cell: TblHeaderCell = self.tableView.dequeueReusableCell(withIdentifier: "TblHeaderCell") as? TblHeaderCell {
            cell.backgroundColor = .lightGray
            cell.selectionStyle = .none
            return cell
        }
        else if  indexPath.row == 1 ,let cell: CategoriesViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoriesViewCell") as? CategoriesViewCell {
            cell.delegate = self
            return cell
        }
        else if  indexPath.row == 2 ,let cell: DeliveringViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DeliveringViewCell") as? DeliveringViewCell {
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectMenu" {
            let viewController: MenuShopVC = segue.destination as! MenuShopVC
            viewController.idShop = 1
        }
    }
}

extension UserViewController: CategoryDelegate {
    func syncContactChanged(isOn: Bool) {
        self.performSegue(withIdentifier: "SelectMenu", sender: self)
    }
}
