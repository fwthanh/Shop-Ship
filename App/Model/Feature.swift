//
//  Feature.swift
//  App
//
//  Created by Pqt Dark on 6/8/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Feature: NSObject, Mappable {
    
    var context_id      : String?
    var context_type    : String?
    var photo_url       : String?
    var title           : String?
    
    required init?(map: Map){
        super.init()
        context_id       <- map["context_id"]
        context_type     <- map["context_type"]
        photo_url        <- map["photo_url"]
        title            <- map["title"]
    }
    
    func mapping(map: Map) {
        context_id       <- map["context_id"]
        context_type     <- map["context_type"]
        photo_url        <- map["photo_url"]
        title            <- map["title"]
    }
}
