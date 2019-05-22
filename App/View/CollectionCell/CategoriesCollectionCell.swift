//
//  CategoriesViewCell.swift
//  App
//
//  Created by Pqt Dark on 4/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class CategoriesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5.0
        bgView.layer.masksToBounds = true
    }
}
