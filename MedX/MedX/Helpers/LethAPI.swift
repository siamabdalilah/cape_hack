//
//  LethAPI.swift
//  MedX
//
//  Created by Griffin Shaw on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import Alamofire

// Place this to test all functions (But update token value)
//let api = LethAPI()
//api.signUp(password: "pass123", completion: {response in
//print(response)
//})
//api.signIn(account: "0xc916cfe5c83dd4fc3c3b0bf2ec2d4e401782875e", password: "WelcomeToSirius", completion: {response in
//print(response)
//})
//api.fetchFile(meta: "QmcGHK3Ye5axzsN5dKJfSz6JbPLqrvx88d31vUyKuSNoSK", token: "eyJibG9ja2NoYWluIjoiRVRIIiwiZXRoX2FkZHJlc3MiOiIweGM5MTZDZmU1YzgzZEQ0RkMzYzNCMEJmMmVjMmQ0ZTQwMTc4Mjg3NWUiLCJpYXQiOjEyODk4LCJlYXQiOjEzODk4fQ.uuDpx4zyfEg5aGD0o-kVgrAs-Us3Hw9DTt-GDssaNvlL3WCdtmPfM3HUWk8BPew7BqWVUmf1F1gCgASLqL2alQA", completion: {response in
//print(response)
//})
//var data: Data? = "{\"message\": \"Hello v2\"}".data(using: .utf8)
//api.addFile(name: "HelloWorldv3.json", type: "application/json", data: data!, completion: {response in
//print(response)
//})

class LethAPI {
    let url: String = "http://ec2-18-222-226-162.us-east-2.compute.amazonaws.com:8080"
    var responses: [String: DataResponse<Any>] = [:]
    
    func signUp(password:String, completion : @escaping (DataResponse<Any>)->()) {
        let resource = "/user/signup"
        let parameters: [String: String] = [ "password" : password]
        
        
        Alamofire.request(url + resource, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                //print(response)
            
                completion(response)
        }
    }
    
    func signIn(account: String, password: String, completion : @escaping (DataResponse<Any>)->()) {
        let resource = "/user/signin"
        let parameters: [String: String] = [ "account": account, "password" : password]
        
        
        Alamofire.request(url + resource, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                //print(response)
                self.responses["signIn"] = response
                
                completion(response)
        }
    }
    
    func addFile(name: String, type: String, data: Data, completion : @escaping (DataResponse<Any>)->()) {
        let resource = "/storage/add"
        let apiURL = url + resource
        let parameters: [String: String] = [ "owner": "0xc916cfe5c83dd4fc3c3b0bf2ec2d4e401782875e", "password" : "WelcomeToSirius"]
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            multipartFormData.append(data, withName: "file", fileName: name, mimeType: type)
            },
            usingThreshold: UInt64.init(),
            to: apiURL,
            method: .post,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        //self.responses["addFile"] = response
                        completion(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func fetchFile(meta: String, token: String, completion : @escaping (DataResponse<Any>)->()) {
        let resource = "/storage/fetch"
        let query = "?meta=" + meta + "&token=" + token
        
        Alamofire.request(url + resource + query, method: .get)
            .responseJSON { response in
                //print(response)
                self.responses["fetchFile"] = response
            completion(response)
        }
    
    }
}

