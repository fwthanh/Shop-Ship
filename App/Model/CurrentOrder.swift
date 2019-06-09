//
//  CurrentOrder.swift
//  App
//
//  Created by Pqt Dark on 6/8/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class CurrentOrder: NSObject, Mappable {
    
    var id              : String?
    var details         : [Post]?
    var distance        : Double?
    var fee_amount      : Double?
    var location        : Location?
    var reason          : String?
    var shop            : Shop?
    var status          : String?
    var subtotal        : Double?
    var total           : Double?
    var address         : String?
    
    required init?(map: Map){
        super.init()
        id              <- map["id"]
        details         <- map["details"]
        distance        <- map["distance"]
        fee_amount      <- map["fee_amount"]
        location        <- map["location"]
        reason          <- map["reason"]
        shop            <- map["shop"]
        status          <- map["status"]
        subtotal        <- map["subtotal"]
        total           <- map["total"]
        address         <- map["address"]
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        details         <- map["details"]
        distance        <- map["distance"]
        fee_amount      <- map["fee_amount"]
        location        <- map["location"]
        reason          <- map["reason"]
        shop            <- map["shop"]
        status          <- map["status"]
        subtotal        <- map["subtotal"]
        total           <- map["total"]
        address         <- map["address"]
    }
}
