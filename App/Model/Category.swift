//
//  Category.swift
//  App
//
//  Created by Pqt Dark on 5/21/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Category: NSObject, Mappable {
    
    var id              : String?
    var avatar_url      : String?
    var name            : String?
    
    init(id             : String,
         name           : String,
         avatar_url     : String)
    {
        self.id             = id
        self.name           = name
        self.avatar_url     = avatar_url
    }
    
    required init?(map: Map){
        super.init()
        id                  <- map["id"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
    }
}
