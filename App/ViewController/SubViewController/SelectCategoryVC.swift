//
//  SelectCategoryVC.swift
//  App
//
//  Created by Pqt Dark on 5/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Kingfisher

class SelectCategoryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var listCategory: [Category]?
    
    var selectCategoryBlock: ((Category) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategory?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width
        return CGSize(width: width/4, height: width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath as IndexPath) as! CategoriesCollectionCell
        cell.backgroundColor = UIColor.clear
        if let category: Category = self.listCategory?[indexPath.row] {
            cell.imgIcon.kf.setImage(with: URL(string: category.avatar_url ?? ""),
                                     placeholder: UIImage(named: "ic_food"),
                                     completionHandler: { (image, _, _, _ ) in
                                        cell.imgIcon.image = image })
            cell.lbName.text = category.name
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        guard let catefory = self.listCategory?[indexPath.row] else { return }
        self.selectCategoryBlock?(catefory)
        self.navigationController?.popViewController(animated: true)
    }

}
