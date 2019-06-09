//
//  DeliveringViewCell.swift
//  App
//
//  Created by Pqt Dark on 4/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import CoreLocation

class DeliveringViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listShop: [Shop]?
    var selectPostBlock: ((Shop, Double) -> Void)?
    var currentDistance: Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listShop?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.width
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeliveringCollectionCell", for: indexPath as IndexPath) as! DeliveringCollectionCell
        cell.backgroundColor = UIColor.clear
        if let shop: Shop = self.listShop?[indexPath.row] {
            cell.lbTitle.text = shop.name
            cell.lbDescription.text = shop.address
            
            cell.imgAvata.kf.setImage(with: URL(string: shop.avatar_url ?? ""), placeholder: UIImage(named: "img_placeholder"), options: nil, progressBlock: nil) { (image, error, _, _) in
                cell.imgAvata.image = image ?? UIImage(named: "img_placeholder")
            }
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(Common.curentLocation?.address ?? "") { (placemarks, error) in
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let lon = placemark?.location?.coordinate.longitude
                
                let coordinate1 = CLLocation(latitude: lat ?? 0.0, longitude: lon ?? 0.0)
                let coordinate2 = CLLocation(latitude: shop.location?.lat ?? 0.0, longitude: shop.location?.lng ?? 0.0)
                let distanceInMeters = coordinate1.distance(from: coordinate2)
                self.currentDistance = distanceInMeters
                cell.lbDetail.text = String(format: "%.2f km", distanceInMeters/1000)
            }
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if let shop = self.listShop?[indexPath.row] {
            self.selectPostBlock?(shop, self.currentDistance)
        }
    }

}
