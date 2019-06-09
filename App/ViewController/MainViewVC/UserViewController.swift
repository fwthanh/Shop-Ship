//
//  FirstViewController.swift
//  App
//
//  Created by Pqt Dark on 4/15/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import CoreLocation
import PullToRefresh
import MapKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableSearchView: UITableView!
    
    var locationManager: CLLocationManager!
    
    var listCategory: [Category]?
    var listShop: [Shop]?
    var listBanner: [Feature]?
    var currentOrder: CurrentOrder?
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // (optional) include this line if you want to remove the extra empty cell divider lines
        self.tableView.tableFooterView = UIView()
        self.tableSearchView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.tableSearchView.tableFooterView = UIView()
        self.tableSearchView.isHidden = true
        self.searchCompleter.delegate = self
        
        FService.sharedInstance.getCategories { (categories, errMsg) in
            self.listCategory = categories
            self.tableView.reloadData()
        }
        
        FService.sharedInstance.getFeaturedBanner { (features, errMsg) in
            self.listBanner = features
            self.tableView.reloadData()
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(tfAddress.text ?? "") { (placemarks, error) in }
        if let currentAddress = Common.curentLocation?.address  {
            self.tfAddress.text = currentAddress
        }
        else {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        }
        
        let refresher = PullToRefresh()
        tableView.addPullToRefresh(refresher) {
            let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                self.tableView.endRefreshing(at: .top)
                self.refreshAllData()
            }
        }
        
        self.refreshAllData()
        self.checkCurrentOrder()
    }

    func checkCurrentOrder() {
        FService.sharedInstance.currentOrder { (currentOrder, errMsg) in
            if currentOrder != nil {
                self.currentOrder = currentOrder
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let selectView: CurrentOrderVC = storyboard.instantiateViewController(withIdentifier: "CurrentOrderVC") as! CurrentOrderVC
                selectView.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 40, height: 460)
                selectView.view.layer.cornerRadius = 10.0
                selectView.view.layer.masksToBounds = true
                self.presentDialogViewController(selectView, animationPattern: .zoomInOut, backgroundViewType: .solid, dismissButtonEnabled: false, completion: nil)
                selectView.setDataInfo(currentOrder: self.currentOrder)
                selectView.btnCancel.add(UIControl.Event.touchUpInside, { (act) in
                    FService.sharedInstance.cancelOrder(idPost: currentOrder?.id ?? "", completion: { (success, errMsg) in
                        if success != nil {
                            self.currentOrder = nil
                            self.dismissDialogViewController(.zoomInOut)
                        }
                    })
                })
            }
        }
    }
    
    func refreshAllData() {
        FService.sharedInstance.getShopBySearch(key: "", lat: Common.curentLocation?.lat ?? 0.0, lng: Common.curentLocation?.lng ?? 0.0, page: 1) { (shops, message) in
            self.listShop = shops
            self.tableView.reloadData()
        }
    }
    
    func getAddress(placemark: CLPlacemark) -> String {
        var addressString : String = ""
        if placemark.thoroughfare != nil {
            addressString = addressString + (placemark.subThoroughfare ?? "") + ", "
        }
        if placemark.thoroughfare != nil {
            addressString = addressString + (placemark.thoroughfare ?? "") + ", "
        }
        if placemark.subLocality != nil {
            addressString = addressString + (placemark.subLocality ?? "") + ", "
        }
        if placemark.subLocality != nil {
            addressString = addressString + (placemark.subAdministrativeArea ?? "") + ", "
        }
        if placemark.locality != nil {
            addressString = addressString + (placemark.locality ?? "")
        }
        return addressString
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 3
        }
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            if indexPath.row == 0 {
                return 150
            }
            else if indexPath.row == 1 {
                var maxRow = 0
                let row = (self.listCategory?.count ?? 0) % 4
                if row > 0 && (self.listCategory?.count ?? 0) < 4 {
                    maxRow = 1
                }
                else if row > 0 {
                    maxRow = (self.listCategory?.count ?? 0)/4 + 1
                }
                else {
                    maxRow = (self.listCategory?.count ?? 0)/4
                }
                return (self.view.bounds.width/4) * CGFloat(maxRow) + CGFloat(maxRow * 15)
            }
            return CGFloat((80 * (self.listShop?.count ?? 0)) + 40)
        }
        else {
            return 40.0
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        if tableView == self.tableView {
            if indexPath.row == 0, let cell: TblHeaderCell = self.tableView.dequeueReusableCell(withIdentifier: "TblHeaderCell") as? TblHeaderCell {
                cell.listBanner = self.listBanner
                cell.selectionStyle = .none
                cell.delegate = self
                cell.collectionView.reloadData()
                cell.pageControl.numberOfPages = self.listBanner?.count ?? 0
                return cell
            }
            else if  indexPath.row == 1 ,let cell: CategoriesViewCell = self.tableView.dequeueReusableCell(withIdentifier: "CategoriesViewCell") as? CategoriesViewCell {
                cell.delegate = self
                cell.listCategory = self.listCategory
                cell.collectionView.reloadData()
                return cell
            }
            else if  indexPath.row == 2 ,let cell: DeliveringViewCell = self.tableView.dequeueReusableCell(withIdentifier: "DeliveringViewCell") as? DeliveringViewCell {
                cell.listShop = self.listShop
                cell.collectionView.reloadData()
                cell.selectPostBlock = { [weak self] (shop, distance) in
                    guard let strongSelf = self else { return }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController: MenuShopVC = storyboard.instantiateViewController(withIdentifier: "MenuShopVC") as! MenuShopVC
                    viewController.shopInfo = shop
                    viewController.currentDistance = distance
                    strongSelf.navigationController?.pushViewController(viewController, animated: true)
                }
                return cell
            }
        }
        else if tableView == self.tableSearchView {
            let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") ?? UITableViewCell()
            let value = self.searchResults[indexPath.row]
            cell.textLabel?.text = value.title + ", " + value.subtitle
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            return cell
        }
        return UITableViewCell()
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if let shop = self.listShop?[indexPath.row] {
                let menuShop = MenuShopVC()
                menuShop.shopInfo = shop
                self.navigationController?.pushViewController(menuShop, animated: true)
            }
        }
        else {
            let value = self.searchResults[indexPath.row]
            self.tfAddress.text = value.title + ", " + value.subtitle
            tableView.isHidden = true
            self.view.endEditing(true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectMenu" {
//            let viewController: MenuShopVC = segue.destination as! MenuShopVC
//            viewController.idShop = ""
        }
    }
}

extension UserViewController: CategoryDelegate, BannerDelegate {
    func selectCategory(categoryId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: ListShopVC = storyboard.instantiateViewController(withIdentifier: "ListShopVC") as! ListShopVC
        viewController.categoryId = categoryId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    func selectShop(shopId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: MenuShopVC = storyboard.instantiateViewController(withIdentifier: "MenuShopVC") as! MenuShopVC
        viewController.shopInfo = nil
        viewController.shopId = shopId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UserViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tableSearchView.isHidden = false
        searchCompleter.queryFragment = textField.text ?? ""
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" && textField.text != Common.curentLocation?.address {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(tfAddress.text ?? "") { (placemarks, error) in
                if let placemark = placemarks?.first, placemark.isoCountryCode == "VN" {
                    let lat = placemark.location?.coordinate.latitude ?? 0.0
                    let long = placemark.location?.coordinate.longitude ?? 0.0
                    Common.curentLocation = Location(lat: lat, lng: long, address: self.tfAddress.text ?? "")
                    FService.sharedInstance.saveLocation(location: Location(lat: lat, lng: long, address: self.tfAddress.text ?? ""), completion: { (success, errMsg) in
                        //OK
                    })
                    self.refreshAllData()
                }
                else {
                    self.tfAddress.text = Common.curentLocation?.address
                }
            }
        }
        else {
            self.tfAddress.text = Common.curentLocation?.address
        }
        self.tableSearchView.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            searchCompleter.queryFragment = updatedText
        }
        self.tableSearchView.isHidden = false
        return true
    }
}

extension UserViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks![0]
                let addressString = self.getAddress(placemark: placemark)
                self.tfAddress.text = addressString
                let currentLocation = Location(lat: userLocation.coordinate.latitude, lng: userLocation.coordinate.longitude, address: addressString)
                Common.curentLocation = currentLocation
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension UserViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
        self.tableSearchView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
}
