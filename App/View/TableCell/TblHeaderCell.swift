//
//  TblHeaderCell.swift
//  App
//
//  Created by Pqt Dark on 4/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

protocol BannerDelegate: class {
    func selectShop(shopId: String)
}

class TblHeaderCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var listBanner: [Feature]?
    weak var delegate: BannerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listBanner?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.width
        return CGSize(width: width, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath as IndexPath) as! HeaderCollectionCell
        let banner = self.listBanner?[indexPath.row]
        cell.imgView.kf.setImage(with: URL(string: banner?.photo_url ?? ""), placeholder: UIImage(named: "img_placeholder"), completionHandler: { (image, _, _, _ ) in
            cell.imgView.image = image ?? UIImage(named: "img_placeholder")
        })
        cell.lbName.text = banner?.title
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if let banner = self.listBanner?[indexPath.row] {
            self.delegate?.selectShop(shopId: banner.context_id ?? "")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
}
