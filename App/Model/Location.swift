//
//  Location.swift
//  App
//
//  Created by Pqt Dark on 6/6/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

@objc(Location)
class Location: NSObject, NSCoding, Mappable {
    
    var lat             : Double?
    var lng             : Double?
    var address         : String?
    
    init(lat            : Double,
         lng            : Double,
         address        : String )
    {
        self.lat        = lat
        self.lng        = lng
        self.address    = address
    }
    
    required init?(map: Map){
        super.init()
        lat                 <- map["lat"]
        lng                 <- map["lng"]
        address             <- map["address"]
    }
    
    func mapping(map: Map) {
        lat                 <- map["lat"]
        lng                 <- map["lng"]
        address             <- map["address"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.lat = aDecoder.decodeObject(forKey: "lat") as? Double
        self.lng = aDecoder.decodeObject(forKey: "lng") as? Double
        self.address = aDecoder.decodeObject(forKey: "address") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lng, forKey: "lng")
        aCoder.encode(address, forKey: "address")
    }
}
