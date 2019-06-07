//
//  CategoriesViewCell.swift
//  App
//
//  Created by Pqt Dark on 4/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

protocol CategoryDelegate: class {
    func syncContactChanged(isOn: Bool)
}

class CategoriesViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var listCategory: [Category]?
    
    weak var delegate: CategoryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listCategory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.width/4
        return CGSize(width: width - 10, height: width - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath as IndexPath) as! CategoriesCollectionCell
        cell.backgroundColor = UIColor.clear
        if let category: Category = self.listCategory?[indexPath.row] {
            cell.lbName.text = category.name
            cell.imgIcon.kf.setImage(with: URL(string: category.avatar_url ?? ""), placeholder: UIImage(named: "img_placeholder"), options: nil, progressBlock: nil) { (image, error, _, _) in
                cell.imgIcon.image = image ?? UIImage(named: "img_placeholder")
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        self.delegate?.syncContactChanged(isOn: true)
    }

}
