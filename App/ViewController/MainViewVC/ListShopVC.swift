//
//  ListShopVC.swift
//  App
//
//  Created by Pqt Dark on 6/8/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import CoreLocation
import PullToRefresh

class ListShopVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryId: String = ""
    var listShop: [Shop]?
    var listShopSearch: [Shop]?
    var currentIndex: Int = 1
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FService.sharedInstance.getShopByCategory(categoryId: categoryId, lat: Common.curentLocation?.lat ?? 0.0, lng: Common.curentLocation?.lng ?? 0.0, page: currentIndex) { (shops, errMsg) in
            if shops != nil {
                self.currentIndex = 2
                self.listShop = shops
                self.collectionView.reloadData()
            }
        }
        
        let refresher = PullToRefresh(height: 44.0, position: .bottom)
        collectionView.addPullToRefresh(refresher) {
            let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.collectionView.endRefreshing(at: .bottom)
                
                FService.sharedInstance.getShopByCategory(categoryId: self.categoryId, lat: Common.curentLocation?.lat ?? 0.0, lng: Common.curentLocation?.lng ?? 0.0, page: self.currentIndex) { (shops, errMsg) in
                    if shops != nil {
                        self.currentIndex += 1
                        self.listShop?.append(contentsOf: shops!)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isSearching == true ? (self.listShopSearch?.count ?? 0) : (self.listShop?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveringCollectionCell", for: indexPath as IndexPath) as! DeliveringCollectionCell
        cell.backgroundColor = UIColor.clear
        if self.isSearching == true {
            if let shop: Shop = self.listShopSearch?[indexPath.row] {
                cell.lbTitle.text = shop.name
                cell.lbDescription.text = shop.address
                
                cell.imgAvata.kf.setImage(with: URL(string: shop.avatar_url ?? ""), placeholder: UIImage(named: "img_placeholder"), options: nil, progressBlock: nil) { (image, error, _, _) in
                    cell.imgAvata.image = image ?? UIImage(named: "img_placeholder")
                }
                
                let coordinate1 = CLLocation(latitude: Common.curentLocation?.lat ?? 0.0, longitude: Common.curentLocation?.lng ?? 0.0)
                let coordinate2 = CLLocation(latitude: shop.location?.lat ?? 0.0, longitude: shop.location?.lng ?? 0.0)
                let distanceInMeters = coordinate1.distance(from: coordinate2)
                cell.lbDetail.text = String(format: "%.2f km", distanceInMeters/1000)
            }
        }
        else {
            if let shop: Shop = self.listShop?[indexPath.row] {
                cell.lbTitle.text = shop.name
                cell.lbDescription.text = shop.address
                
                cell.imgAvata.kf.setImage(with: URL(string: shop.avatar_url ?? ""), placeholder: UIImage(named: "img_placeholder"), options: nil, progressBlock: nil) { (image, error, _, _) in
                    cell.imgAvata.image = image ?? UIImage(named: "img_placeholder")
                }
                
                let coordinate1 = CLLocation(latitude: Common.curentLocation?.lat ?? 0.0, longitude: Common.curentLocation?.lng ?? 0.0)
                let coordinate2 = CLLocation(latitude: shop.location?.lat ?? 0.0, longitude: shop.location?.lng ?? 0.0)
                let distanceInMeters = coordinate1.distance(from: coordinate2)
                cell.lbDetail.text = String(format: "%.2f km", distanceInMeters/1000)
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isSearching == true {
            if let shop: Shop = self.listShopSearch?[indexPath.row] {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController: MenuShopVC = storyboard.instantiateViewController(withIdentifier: "MenuShopVC") as! MenuShopVC
                viewController.shopInfo = shop
                let coordinate1 = CLLocation(latitude: Common.curentLocation?.lat ?? 0.0, longitude: Common.curentLocation?.lng ?? 0.0)
                let coordinate2 = CLLocation(latitude: shop.location?.lat ?? 0.0, longitude: shop.location?.lng ?? 0.0)
                let distanceInMeters = coordinate1.distance(from: coordinate2)
                viewController.currentDistance = distanceInMeters
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else {
            if let shop: Shop = self.listShop?[indexPath.row] {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController: MenuShopVC = storyboard.instantiateViewController(withIdentifier: "MenuShopVC") as! MenuShopVC
                viewController.shopInfo = shop
                let coordinate1 = CLLocation(latitude: Common.curentLocation?.lat ?? 0.0, longitude: Common.curentLocation?.lng ?? 0.0)
                let coordinate2 = CLLocation(latitude: shop.location?.lat ?? 0.0, longitude: shop.location?.lng ?? 0.0)
                let distanceInMeters = coordinate1.distance(from: coordinate2)
                viewController.currentDistance = distanceInMeters
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

}

extension ListShopVC: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearching = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.isSearching = true
            FService.sharedInstance.getShopBySearch(key: searchText, lat: Common.curentLocation?.lat ?? 0.0, lng: Common.curentLocation?.lng ?? 0.0, page: 1) { (shops, message) in
                self.listShopSearch = shops
                self.collectionView.reloadData()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.isSearching = false
        self.collectionView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search")
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearching = true
    }
}
