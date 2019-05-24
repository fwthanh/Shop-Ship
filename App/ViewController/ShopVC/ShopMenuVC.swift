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
    @IBOutlet weak var btnCreate: UIButton!
    
    var listPost: [Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnCreate.layer.cornerRadius = 25.0
        btnCreate.layer.masksToBounds = true
        
        self.tableView.tableFooterView = UIView()
        
        FService.sharedInstance.getShopProfile { (shop, errMsg) in
            if shop == nil && errMsg == nil {
                let alert = UIAlertController(title: "Cập nhật thông tin", message: "Vui lòng cập nhật thông tin của bạn!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.tabBarController?.selectedIndex = 2
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                FService.sharedInstance.getPostShop(completion: { (post, errMsg) in
                    if post != nil {
                        self.listPost = post?.post ?? []
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listPost.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        if let cell: MenuTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as? MenuTableViewCell {
            cell.selectionStyle = .none
            let postInfo = self.listPost[indexPath.row]
            cell.lbName.text = postInfo.name
            cell.lbDesc.text = postInfo.desc
            cell.lbPrice.text = postInfo.price?._vnCurrencyString
            cell.imgAvata.kf.setImage(with: URL(string: postInfo.avatar_url ?? ""),
                                 placeholder: UIImage(named: "ic_food"),
                                 completionHandler: { (image, _, _, _ ) in
                                    cell.imgAvata.image = image })
            return cell
        }
        else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postInfo = self.listPost[indexPath.row]
        self.performSegue(withIdentifier: "CreateMenu", sender: postInfo)
    }
    
    @IBAction func createAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "CreateMenu", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateMenu" {
            let viewController: CreateMenuVC = segue.destination as! CreateMenuVC
            viewController.postInfo = sender as? Post
            viewController.addPostBlock = { [weak self] (message) in
                guard let strongSelf = self else { return }
                FService.sharedInstance.getPostShop(completion: { (post, errMsg) in
                    if post != nil {
                        strongSelf.listPost.removeAll()
                        strongSelf.listPost = post?.post ?? []
                        strongSelf.tableView.reloadData()
                    }
                })
            }
        }
    }
}
