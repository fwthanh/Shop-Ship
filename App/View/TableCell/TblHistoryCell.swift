//
//  TblHistoryCell.swift
//  App
//
//  Created by Pqt Dark on 5/4/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

class TblHistoryCell: UITableViewCell {

    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var imgEnd: UIImageView!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var lbAddress1: UILabel!
    @IBOutlet weak var lbAddress2: UILabel!
    @IBOutlet weak var lbOrderCode: UILabel!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgStart.layer.cornerRadius = 10.0
        self.imgStart.layer.masksToBounds = true
        
        self.viewContent.layer.cornerRadius = 5.0
        self.viewContent.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
