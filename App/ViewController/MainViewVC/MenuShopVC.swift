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
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    var shopInfo: Shop?
    var listPost: [Post] = [Post]()
    let btnCart = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
    let lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 16, height: 16))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
        
        btnCart.setImage(UIImage(named: "ic_shop"), for: .normal)
        btnCart.setImage(UIImage(named: "ic_shop_2"), for: .disabled)
        btnCart.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        lblBadge.backgroundColor = UIColor.red
        lblBadge.clipsToBounds = true
        lblBadge.layer.cornerRadius = 8
        lblBadge.textColor = UIColor.white
        lblBadge.font = UIFont.systemFont(ofSize: 9)
        lblBadge.textAlignment = .center
        lblBadge.isHidden = true
        btnCart.addSubview(lblBadge)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: btnCart)]
        
        self.lbName.text = shopInfo?.name
        self.lbAddress.text = shopInfo?.address
        self.imgCover.kf.setImage(with: URL(string: shopInfo?.cover_url ?? ""), placeholder: UIImage(named: "img_placeholder"), completionHandler: { (image, _, _, _ ) in
            self.imgCover.image = image ?? UIImage(named: "img_placeholder")
        })
        self.btnCart.isEnabled = false
        
        FService.sharedInstance.getPostOfShop(idShop: shopInfo?.id ?? "") { (posts, errMsg) in
            if errMsg == nil {
                self.listPost = posts ?? []
                self.tableView.reloadData()
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
                                      placeholder: UIImage(named: "img_placeholder"),
                                      completionHandler: { (image, _, _, _ ) in
                                        cell.imgAvata.image = image ?? UIImage(named: "img_placeholder")})
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
        let post = self.listPost[indexPath.row]
        selectView.postInfo = post
        selectView.dismissDialogBlock = { [weak self] (itemSelected) in
            guard let strongSelf = self else { return }
            strongSelf.dismissDialogViewController(.slideBottomBottom)
            if itemSelected != -1 {
                post.numSelected = itemSelected
            }
            
            let postSelected = strongSelf.listPost.filter {
                $0.numSelected > 0
            }
            strongSelf.btnCart.isEnabled = (postSelected.count > 0)
            strongSelf.lblBadge.text = "\(postSelected.count)"
            strongSelf.lblBadge.isHidden = !(postSelected.count > 0)
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
