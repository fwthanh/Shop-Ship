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

class Category: NSObject, NSCoding, Mappable {
    
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
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_url, forKey: "avatar_url")
    }
}
