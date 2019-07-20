//
//  LethAPI.swift
//  MedX
//
//  Created by Griffin Shaw on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

class LethAPI {
    let aws: String = "https://ec2-18-222-226-162.us-east-2.compute.amazonaws.com:8080"
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func signUp(password: String) -> String {
        let urlString = aws + "/user/signup"
        return urlString
    }
    
    func signIn(pubKey: String, password: String) -> String {
        let urlString = aws + "/user/signin"
        return urlString
    }
    
    // TODO: Pass this function a file, or the location with which to get the file.
    func addFile() {
        //let dest = aws + "/storage/add"
        
    }
    
    func fetchFile(meta: String, token: String) {
        let urlString = aws + "/storage/fetch"
        
        //temp
        let meta1 = "QmcGHK3Ye5axzsN5dKJfSz6JbPLqrvx88d31vUyKuSNoSK"
        let token1 = "eyJibG9ja2NoYWluIjoiRVRIIiwiZXRoX2FkZHJlc3MiOiIweGM5MTZDZmU1YzgzZEQ0RkMzYzNCMEJmMmVjMmQ0ZTQwMTc4Mjg3NWUiLCJpYXQiOjEwMDQ2LCJlYXQiOjExMDQ2fQ.X86hAba2Fz759fOJwRZYUHYebG9uCTRwwN4dtG1L9HNU3AdJ0d5lh6CsJrurTxTtKUb8Z8mteLter16VIf2DnAE"
        let query = "?meta=" + meta1 + "&token" + token1
        let url = URL(string: urlString + query)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        
        task.resume()
    }
    
    
    
}
