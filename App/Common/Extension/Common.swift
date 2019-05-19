//
//  Common.swift
//  App
//
//  Created by Pqt Dark on 5/19/19.
//  Copyright © 2019 Pqt. All rights reserved.
//

import UIKit
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
    
}

extension DefaultsKeys {
    static let token            = DefaultsKey<String?>("token")
}

public let ACUserDefault = UserDefaults(suiteName: "App")
