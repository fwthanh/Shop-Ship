//
//  MenuShopVC.swift
//  App
//
//  Created by Pqt Dark on 5/5/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import LSDialogViewController

class MenuShopVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCart: UIBarButtonItem!
    
    var idShop: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        self.btnCart.isEnabled = false
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
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        self.performSegue(withIdentifier: "OrderInfo", sender: self)
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectView: SelectMenuVC = storyboard.instantiateViewController(withIdentifier: "SelectMenuVC") as! SelectMenuVC
        /*
        finsightsEnableAlert.enableFinsightsBlock = { [weak self] in
            guard let strongSelf = self else { return }
            //
        }
         */
        selectView.dismissDialogBlock = { [weak self] (itemSelected) in
            guard let strongSelf = self else { return }
            strongSelf.dismissDialogViewController(.slideBottomBottom)
            strongSelf.btnCart.isEnabled = (itemSelected > 0)
        }
 
        self.presentDialogViewController(selectView, animationPattern: .slideBottomTop, backgroundViewType: .solid, dismissButtonEnabled: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderInfo" {
            let viewController: OrderInfoViewController = segue.destination as! OrderInfoViewController
            //viewController.idShop = 1
        }
    }
}
