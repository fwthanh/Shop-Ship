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

@objc(User)
class User: NSObject, NSCoding, Mappable {
    
    var id              : String?
    var first_name      : String?
    var last_name       : String?
    var name            : String?
    var avatar_url      : String?
    var cover_url       : String?
    var phone_contact   : String?
    var address         : String?
    
    init(id             : String,
         first_name     : String,
         last_name      : String,
         name           : String,
         avatar_url     : String,
         cover_url      : String,
         phone_contact  : String,
         address        : String )
    {
        self.id             = id
        self.first_name     = first_name
        self.last_name      = last_name
        self.name           = name
        self.avatar_url     = avatar_url
        self.cover_url      = cover_url
        self.phone_contact  = phone_contact
        self.address        = address
    }
    
    required init?(map: Map){
        super.init()
        id                  <- map["id"]
        first_name          <- map["first_name"]
        last_name           <- map["last_name"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
        cover_url           <- map["cover_url"]
        phone_contact       <- map["phone_contact"]
        address             <- map["address"]
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        first_name          <- map["first_name"]
        last_name           <- map["last_name"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
        cover_url           <- map["cover_url"]
        phone_contact       <- map["phone_contact"]
        address             <- map["address"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.first_name = aDecoder.decodeObject(forKey: "first_name") as? String
        self.last_name = aDecoder.decodeObject(forKey: "last_name") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as? String
        self.cover_url = aDecoder.decodeObject(forKey: "cover_url") as? String
        self.phone_contact = aDecoder.decodeObject(forKey: "phone_contact") as? String
        self.address = aDecoder.decodeObject(forKey: "address") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(first_name, forKey: "first_name")
        aCoder.encode(last_name, forKey: "last_name")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_url, forKey: "avatar_url")
        aCoder.encode(cover_url, forKey: "cover_url")
        aCoder.encode(phone_contact, forKey: "phone_contact")
        aCoder.encode(address, forKey: "address")
    }
}
