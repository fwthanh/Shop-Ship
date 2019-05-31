//
//  Post.swift
//  App
//
//  Created by Pqt Dark on 5/24/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Post: NSObject, Mappable {
    
    var id              : String?
    var quantity        : Int?
    var promo_price     : Double?
    var price           : Double?
    var status          : String?
    var desc            : String?
    var avatar_url      : String?
    var name            : String?
    var discount        : Discount?
    
    init(id             : String,
         quantity       : Int,
         promo_price    : Double,
         price          : Double,
         status         : String,
         desc           : String,
         avatar_url     : String,
         name           : String,
         discount       : Discount)
    {
        self.id             = id
        self.quantity       = quantity
        self.promo_price    = promo_price
        
        self.price          = price
        self.status         = status
        self.desc           = desc
        self.avatar_url     = avatar_url
        self.name           = name
        self.discount       = discount
    }
    
    required init?(map: Map){
        super.init()
        id                  <- map["id"]
        quantity            <- map["quantity"]
        promo_price         <- map["promo_price"]
        price               <- map["price"]
        status              <- map["status"]
        desc                <- map["description"]
        avatar_url          <- map["avatar_url"]
        name                <- map["name"]
        discount            <- map["discount"]
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        quantity            <- map["quantity"]
        promo_price         <- map["promo_price"]
        price               <- map["price"]
        status              <- map["status"]
        desc                <- map["description"]
        avatar_url          <- map["avatar_url"]
        name                <- map["name"]
        discount            <- map["discount"]
    }
}

class Page: NSObject, Mappable {
    
    var page            : Int?
    var limit           : Int?

    init(page           : Int,
         limit          : Int )
    {
        self.page       = page
        self.limit      = limit
    }
    
    required init?(map: Map){
        super.init()
        page                <- map["page"]
        limit               <- map["limit"]
    }
    
    func mapping(map: Map) {
        page                <- map["page"]
        limit               <- map["limit"]
    }
}

class DataPost: NSObject, Mappable {
    
    var page            : Page?
    var post            : [Post]?
    
    init(page           : Page,
         post           : [Post] )
    {
        self.page       = page
        self.post       = post
    }
    
    required init?(map: Map){
        super.init()
        page                <- map["filter"]
        post                <- map["post"]
    }
    
    func mapping(map: Map) {
        page                <- map["filter"]
        post                <- map["results"]
    }
}

class Discount: NSObject, Mappable {
    
    var type            : String?
    var value           : Double?
    
    init(type           : String,
         value          : Double )
    {
        self.type       = type
        self.value      = value
    }
    
    required init?(map: Map){
        super.init()
        type                <- map["type"]
        value               <- map["value"]
    }
    
    func mapping(map: Map) {
        type                <- map["type"]
        value               <- map["value"]
    }
}
