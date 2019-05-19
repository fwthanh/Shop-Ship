//
//  FService.swift
//  Folotrail
//
//  Created by Phan Quoc Thanh on 9/1/17.
//  Copyright © 2017 PQT. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import PKHUD

class FService: NSObject {
    
    static let sharedInstance = FService()
    static let baseURLString = "http://ec2-52-77-233-153.ap-southeast-1.compute.amazonaws.com/"
    
    static let getConfigUrl         = "index.php?op=api&action=getConfig"
    static let loginUrl             = "api/v1/auth/token"
    static let forgotUrl            = "index.php?op=api&action=forgot"
    static let registerUrl          = "index.php?op=api&action=register"
    static let addAccountUrl        = "index.php?op=api&action=addAccount"
    static let getScenariotUrl      = "index.php?op=api&action=getScenario"
    static let getAccountListUrl    = "index.php?op=api&action=getAccountList"
    static let updateScenarioUrl    = "index.php?op=api&action=updateScenario"
    static let getStatisticUrl      = "index.php?op=api&action=getStatistic"
    static let removeAccountUrl     = "index.php?op=api&action=removeAccount"
    
    func request (url: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        let endpoint: String = FService.baseURLString + url
        Alamofire.request(endpoint, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            guard response.result.isSuccess else {
                completion(nil, response.result.error)
                return
            }
            
            guard let value = response.result.value as? [String: Any] else {
                completion(nil, nil)
                return
            }
            completion(value, nil)
        }
    }
    
    func login(code : String, role: String, completion: @escaping (_ token: String?,_ errMsg: String?) -> ()) -> () {
        
        request(url: FService.loginUrl, method: .post, params: ["code": code, "role" : role ]) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    completion(data["token"] as? String, nil)
                }
                else {
                    completion(nil, nil)
                }
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
}
