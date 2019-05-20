//
//  User.swift
//  App
//
//  Created by Pqt Dark on 5/20/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class User: NSObject, NSCoding, Mappable {
    
    var id              : String?
    var first_name      : String?
    var last_name       : String?
    var name            : String?
    var avatar_url      : String?
    var phone_contact   : String?
    
    init(id             : String,
         first_name     : String,
         last_name      : String,
         name           : String,
         avatar_url     : String,
         phone_contact  : String )
    {
        self.id             = id
        self.first_name     = first_name
        self.last_name      = last_name
        self.name           = name
        self.avatar_url     = avatar_url
        self.phone_contact  = phone_contact
    }
    
    required init?(map: Map){
        super.init()
        id                  <- map["id"]
        first_name          <- map["first_name"]
        last_name           <- map["last_name"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
        phone_contact       <- map["phone_contact"]
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        first_name          <- map["first_name"]
        last_name           <- map["last_name"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
        phone_contact       <- map["phone_contact"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as? String
        self.phone_contact = aDecoder.decodeObject(forKey: "phone_contact") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_url, forKey: "avatar_url")
        aCoder.encode(phone_contact, forKey: "phone_contact")
    }
}
