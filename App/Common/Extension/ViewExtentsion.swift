//
//  ViewExtentsion.swift
//  App
//
//  Created by Pqt Dark on 4/20/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit

extension UIView {
    //MARK:- CORNER RADIUS
    func applyCornerRadius(radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func applyCornerRadiusDefault() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.applyCornerRadius(radius: 8.0)
    }
    
    //MARK:- SHADOW
    func applyShadowDefault()   {
        self.applyShadowWithColor(color: UIColor.black, opacity: 0.5, radius: 1)
    }
    
    func applyShadowWithColor(color:UIColor)    {
        self.applyShadowWithColor(color: color, opacity: 0.5, radius: 1)
    }
    
    func applyShadowWithColor(color:UIColor, opacity:Float, radius: CGFloat)    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
    }
}
