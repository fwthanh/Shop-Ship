//
//  Shop.swift
//  App
//
//  Created by Pqt Dark on 5/20/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Shop: NSObject, NSCoding, Mappable {
    
    var id              : String?
    var email           : String?
    var address         : String?
    var cover_url       : String?
    var name            : String?
    var avatar_url      : String?
    var phone_contact   : String?
    
    init(id             : String,
         email          : String,
         address        : String,
         cover_url      : String,
         name           : String,
         avatar_url     : String,
         phone_contact  : String )
    {
        self.id             = id
        self.address        = address
        self.cover_url      = cover_url
        self.name           = name
        self.avatar_url     = avatar_url
        self.phone_contact  = phone_contact
    }
    
    required init?(map: Map){
        super.init()
        id                  <- map["id"]
        address             <- map["address"]
        cover_url           <- map["cover_url"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
        phone_contact       <- map["phone_contact"]
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        address             <- map["address"]
        cover_url           <- map["cover_url"]
        name                <- map["name"]
        avatar_url          <- map["avatar_url"]
        phone_contact       <- map["phone_contact"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.address = aDecoder.decodeObject(forKey: "address") as? String
        self.cover_url = aDecoder.decodeObject(forKey: "cover_url") as? String
        self.name = aDecoder.decodeObject(forKey: "name") as? String
        self.avatar_url = aDecoder.decodeObject(forKey: "avatar_url") as? String
        self.phone_contact = aDecoder.decodeObject(forKey: "phone_contact") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(cover_url, forKey: "cover_url")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(avatar_url, forKey: "avatar_url")
        aCoder.encode(phone_contact, forKey: "phone_contact")
    }
}
