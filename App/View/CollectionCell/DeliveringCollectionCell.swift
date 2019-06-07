//
//  DeliveringCollectionCell.swift
//  App
//
//  Created by Pqt Dark on 4/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class DeliveringCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgAvata: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvata.layer.cornerRadius = 5.0
        imgAvata.layer.masksToBounds = true
    }
}
