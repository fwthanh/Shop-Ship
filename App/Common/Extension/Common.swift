//
//  Common.swift
//  App
//
//  Created by Pqt Dark on 5/19/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
import Foundation
import SwiftyUserDefaults

struct Common {
    
    static var token : String? {
        get {
            if ACUserDefault?[.token] == nil {
                ACUserDefault?[.token] = ""
            }
            return ACUserDefault?[.token]
        }
        set {
            ACUserDefault?[.token] = newValue
            ACUserDefault?.synchronize()
        }
    }
    
    static var role : String? {
        get {
            if ACUserDefault?[.role] == nil {
                ACUserDefault?[.role] = ""
            }
            return ACUserDefault?[.role]
        }
        set {
            ACUserDefault?[.role] = newValue
            ACUserDefault?.synchronize()
        }
    }
    
    static var userInfo : User? {
        get {
            return ACUserDefault?[.curentUserInfo]
        }
        set {
            ACUserDefault?[.curentUserInfo] = newValue
        }
    }
    
    static var shopInfo : Shop? {
        get {
            return ACUserDefault?[.curentShopInfo]
        }
        set {
            ACUserDefault?[.curentShopInfo] = newValue
        }
    }
    
    static var curentLocation : Location? {
        get {
            return ACUserDefault?[.curentLocation]
        }
        set {
            ACUserDefault?[.curentLocation] = newValue
        }
    }
}

extension DefaultsKeys {
    static let token            = DefaultsKey<String?>("token")
    static let role             = DefaultsKey<String?>("role")
    static let curentUserInfo   = DefaultsKey<User?>("curentUserInfo")
    static let curentShopInfo   = DefaultsKey<Shop?>("curentShopInfo")
    static let curentLocation   = DefaultsKey<Location?>("curentLocation")
}

extension UserDefaults {
    
    subscript(key: DefaultsKey<User?>) -> User? {
        get {
            NSKeyedArchiver.setClassName("User", for: User.self)
            return unarchive(key)
        }
        set {
            NSKeyedUnarchiver.setClass(User.self, forClassName: "User")
            archive(key, newValue)
        }
    }
    
    subscript(key: DefaultsKey<Shop?>) -> Shop? {
        get {
            NSKeyedArchiver.setClassName("Shop", for: Shop.self)
            return unarchive(key)
        }
        set {
            NSKeyedUnarchiver.setClass(Shop.self, forClassName: "Shop")
            archive(key, newValue)
        }
    }
    
    subscript(key: DefaultsKey<Location?>) -> Location? {
        get {
            NSKeyedArchiver.setClassName("Location", for: Location.self)
            return unarchive(key)
        }
        set {
            NSKeyedUnarchiver.setClass(Location.self, forClassName: "Location")
            archive(key, newValue)
        }
    }
}

public let ACUserDefault = UserDefaults(suiteName: "App")
