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
    ////USER////
    static let getConfigUrl         = "index.php?op=api&action=getConfig"
    static let loginUrl             = "api/v1/auth/token"
    static let getProfileUrl        = "api/v1/users/me"
    ////SHOP////
    static let getProfileShop       = "api/v1/shops/current"
    static let saveProfileShop      = "api/v1/shops/current"
    static let getCategories        = "api/v1/categories"
    
    ////MEDIA////
    static let uploadImageUrl       = "api/v1/medias"
    
    
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
    
    func requestAuthorization(url: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        let endpoint: String = FService.baseURLString + url
        let headers = [
            "Authorization": "Bearer \(Common.token ?? "")",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        Alamofire.request(endpoint, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
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
    
    // MARK: - UPLOAD
    func uploadImage(url: String, image: UIImage, completion: @escaping (_ result: [String]?, _ error: Error?) -> ()) -> () {
        
        let imgData = image.jpegData(compressionQuality: 0.4)
        let parameters = ["file": imgData]
        
        let url: String = FService.baseURLString + url
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Common.token ?? "")",
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value ?? Data())".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imgData{
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard response.result.isSuccess else {
                        completion(nil, response.result.error)
                        return
                    }
                    
                    guard let value = response.result.value as? [String: Any] else {
                        completion(nil, nil)
                        return
                    }
                    
                    if let data = value["data"] as? [String: Any] {
                        completion(data["media_ids"] as? [String], nil)
                    }
                    else {
                        completion(nil, nil)
                    }
                }
            case .failure(let error):
                completion(nil, error.localizedDescription as? Error)
            }
        }
    }
    
    // MARK: - USER
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
                Common.role = role
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    func getUserProfile(completion: @escaping (_ user: User?,_ errMsg: String?) -> ()) -> () {
        
        requestAuthorization(url: FService.getProfileUrl, method: .get, params: nil) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    let userInfo = Mapper<User>().map(JSON: data)
                    completion(userInfo, nil)
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
    
    // MARK: - SHOP
    func getCategories(completion: @escaping (_ categories: [Category]?,_ errMsg: String?) -> ()) -> () {
        
        requestAuthorization(url: FService.getCategories, method: .get, params: nil) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    
                    if let resultData = data["results"] as? [[String: Any]] {
                        let categories  = Mapper<Category>().mapArray(JSONArray: resultData)
                        completion(categories, nil)
                    }
                    else {
                        completion([], nil)
                    }
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
    
    func getShopProfile( completion: @escaping (_ shop: Shop?,_ errMsg: String?) -> ()) -> () {

        requestAuthorization(url: FService.getProfileShop, method: .get, params: nil) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    let shopInfo = Mapper<Shop>().map(JSON: data)
                    Common.shopInfo = shopInfo
                    completion(shopInfo, nil)
                }
                else {
                    completion(nil, nil)
                }
            }
            else if let code = result?["http_status"] as? Int, code == 404 {
                completion(nil, nil)
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    func saveShopProfile(avatar_id: String,
                         cover_id: String,
                         name: String,
                         address: String,
                         location: [String: Any],
                         completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        
        let params = ["avatar_id": avatar_id,
                      "cover_id": cover_id,
                      "name": name,
                      "address": address,
                      "location": location ] as [String : Any]
        
        requestAuthorization(url: FService.saveProfileShop, method: .put, params: params) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    completion("success", nil)
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
