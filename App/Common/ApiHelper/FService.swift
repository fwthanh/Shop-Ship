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
    static let saveProfileUrl       = "api/v1/users/me"
    ////SHOP////
    static let createProfileShop    = "api/v1/shops"
    static let getProfileShop       = "api/v1/shops/current"
    static let saveProfileShop      = "api/v1/shops/current"
    static let getCategories        = "api/v1/categories"
    static let getMenuShop          = "api/v1/shops/current/categories"
    static let createMenuShop       = "api/v1/shops/current/posts"
    static let getPostShop          = "api/v1/shops/current/posts"
    static let editPostShop         = "api/v1/shops/current/posts/"
    static let shopListBySearch     = "api/v1/shops/search?q=%@&sort=nearby&page=%d&lat=%f&lng=%f"
    ////POST/////
    static let listPostOfShop       = "api/v1/shops/%@/posts"
    
    ////MEDIA////
    static let uploadImageUrl       = "api/v1/medias"
    ////LOCATION////
    static let saveLocation         = "api/v1/users/me/location"
    
    // MARK: - REQUEST
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
    
    func requestBody(url: String, method: HTTPMethod, params: [String: Any]?, completion: @escaping (_ result: [String: Any]?, _ error: Error?) -> Void) {
        let urlString: String = FService.baseURLString + url
        
        let json = params?.jsonStringRepresentation ?? ""
        
        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Common.token ?? "")", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON {
            (response) in
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
                Common.role = role
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
    
    func saveUserProfile(avatar_id: String,
                         cover_id: String,
                         name: String,
                         address: String,
                         location: [String: Any],
                         completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        var params = [:] as [String : Any]
        if avatar_id == "" && cover_id == "" {
            params = ["name": name,
                      "address": address,
                      "location": location ] as [String : Any]
        }
        else if avatar_id != "" && cover_id != "" {
            params = ["avatar_id": avatar_id,
                      "cover_id": cover_id,
                      "name": name,
                      "address": address,
                      "location": location ] as [String : Any]
        }
        else if avatar_id == "" && cover_id != "" {
            params = ["cover_id": cover_id,
                      "name": name,
                      "address": address,
                      "location": location ] as [String : Any]
        }
        else {
            params = ["avatar_id": avatar_id,
                      "name": name,
                      "address": address,
                      "location": location ] as [String : Any]
        }
        
        requestBody(url: FService.saveProfileUrl, method: .put, params: params) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if (result?["data"] as? [String: Any]) != nil {
                    self.getUserProfile(completion: { (user, errMsg) in
                        Common.userInfo = user
                    })
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
    
    func createShopProfile(category_id: String,
                           avatar_id: String,
                           cover_id: String,
                           name: String,
                           address: String,
                           location: [String: Any],
                           completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        let params = ["category_id" : category_id,
                      "avatar_id": avatar_id,
                      "cover_id": cover_id,
                      "name": name,
                      "address": address,
                      "location": location ] as [String : Any]
        
        requestBody(url: FService.createProfileShop, method: .post, params: params) { (result, error) in
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    let idShop = data["id"] as? String ?? ""
                    completion(idShop, nil)
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
                if (result?["data"] as? [String: Any]) != nil {
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
    
    func saveNameShopProfile(name: String, address: String, location: [String: Any], completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        let params = ["name": name, "address": address, "location": location] as [String : Any]
        requestBody(url: FService.saveProfileShop, method: .put, params: params) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                completion("success", nil)
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    func saveAvataShopProfile(avatar_id: String, completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        let params = ["avatar_id": avatar_id] as [String : Any]
        requestBody(url: FService.saveProfileShop, method: .put, params: params) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                completion("success", nil)
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    func saveCoverShopProfile(cover_id: String, completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        let params = ["cover_id": cover_id] as [String : Any]
        requestBody(url: FService.saveProfileShop, method: .put, params: params) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                completion("success", nil)
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    func createPost(name: String, description: String, quantity: Int, price: Double, discount: [String: Any], avatar_id: String, completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        let params = ["name": name,
                      "description": description,
                      "quantity": quantity,
                      "price": price,
                      "discount": discount,
                      "avatar_id": avatar_id] as [String : Any]
        requestBody(url: FService.createMenuShop, method: .post, params: params) { (result, error) in
            let status: String = result?["status"] as! String
            if status == "success" {
                completion("success", nil)
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    func getPostShop( completion: @escaping (_ shop: DataPost?,_ errMsg: String?) -> ()) -> () {
        
        requestAuthorization(url: FService.getPostShop, method: .get, params: nil) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    let postInfo = Mapper<DataPost>().map(JSON: data)
                    completion(postInfo, nil)
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
    
    func editPost(idPost: String, name: String, description: String, quantity: Int, price: Double, discount: [String: Any], avatar_id: String, completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        var params = [String:Any]()
        if avatar_id == "" {
            params = ["name": name,
                      "description": description,
                      "quantity": quantity,
                      "price": price,
                      "discount": discount] as [String : Any]
        }
        else {
            params = ["name": name,
                      "description": description,
                      "quantity": quantity,
                      "price": price,
                      "discount": discount,
                      "avatar_id": avatar_id] as [String : Any]
        }

        requestBody(url: FService.editPostShop + idPost, method: .put, params: params) { (result, error) in
            let status: String = result?["status"] as! String
            if status == "success" {
                completion("success", nil)
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    func getShopBySearch(key: String, lat: Double, lng: Double, page: Int, completion: @escaping (_ categories: [Shop]?,_ errMsg: String?) -> ()) -> () {
        
        let endpoint = String(format: FService.shopListBySearch, key, page, lat, lng)
        requestAuthorization(url: endpoint, method: .get, params: nil) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    
                    if let resultData = data["results"] as? [[String: Any]] {
                        let categories  = Mapper<Shop>().mapArray(JSONArray: resultData)
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
    
    func saveLocation(location: Location,
                      completion: @escaping (_ success: String?,_ errMsg: String?) -> ()) -> () {
        
        
        let params = ["lat": location.lat ?? 0.0,
                      "lng": location.lng ?? 0.0,
                      "address": location.address ?? ""] as [String : Any]
        
        requestBody(url: FService.saveLocation, method: .put, params: params) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if (result?["data"] as? [String: Any]) != nil {
                    completion("success", nil)
                }
                else {
                    completion(nil, result?["message"] as? String)
                }
            }
            else {
                completion(nil, result?["message"] as? String)
            }
        }
    }
    
    // MARK: - POST
    func getPostOfShop(idShop: String, completion: @escaping (_ categories: [Post]?,_ errMsg: String?) -> ()) -> () {
        
        let endpoint = String(format: FService.listPostOfShop, idShop)
        requestAuthorization(url: endpoint, method: .get, params: nil) { (result, error) in
            
            let status: String = result?["status"] as! String
            if status == "success" {
                if let data = result?["data"] as? [String: Any] {
                    
                    if let resultData = data["results"] as? [[String: Any]] {
                        let categories  = Mapper<Post>().mapArray(JSONArray: resultData)
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
}
