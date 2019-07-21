//
//  ViewController.swift
//  MedX
//
//  Created by user on 7/19/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SQLite3
import SendBirdSDK
class ViewController: UIViewController, URLSessionDelegate {
    var hospital: String?
    @IBOutlet weak var publicKey: UITextField!
    @IBOutlet weak var password: UITextField!
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.5836969018, green: 0.7517433167, blue: 0.8807654977, alpha: 1)
        var key = sqliteOps.instance.readFromSQLite(table: "pub")
        if key != "" {
            publicKey.text = "0xc916cfe5c83dd4fc3c3b0bf2ec2d4e401782875e"
            password.text = "WelcomeToSirius"
        }
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @IBAction func signUp(sender: UIButton) {
        if password.text != "" {
            if publicKey.text != "" {
                signInRequest(publicKey: publicKey.text!, password: password.text!)
            }else{
                signUpRequest(password: password.text!)
            }
        }
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    func signUpRequest(password: String){
        let endpoint: String = "http://ec2-18-222-226-162.us-east-2.compute.amazonaws.com:8080/user/signup"
        guard let createUrl = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: createUrl)
        urlRequest.httpMethod = "POST"
        let input: [String: Any] = ["password": password]
        let json: Data
        do {
            json = try JSONSerialization.data(withJSONObject: input, options: [])
            urlRequest.httpBody = json
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: self, // DO NOT FORGET YOUR OBJECT HERE!!
            delegateQueue: nil)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedPub = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                    else {
                        print("Could not get JSON from responseData as dictionary")
                        return
                }
                print(receivedPub.description)
                guard let key = receivedPub["account"] as? String else {
                    return
                }
                print("The key is: \(key)")
                sqliteOps.instance.createTableInSQLite(tableName: "pub")
                sqliteOps.instance.prepareAndInsertToSQLite(table: "pub", field: "key", value: key)
                self.signInRequest(publicKey: sqliteOps.instance.readFromSQLite(table: "pub"), password: password)
            } catch  {
                print("error parsing response from POST on /todos")

                return
            }
        }
        task.resume()
    }
    func signInRequest(publicKey: String, password: String){
        let endpoint: String = "http://ec2-18-222-226-162.us-east-2.compute.amazonaws.com:8080/user/signin"
        guard let createUrl = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: createUrl)
        urlRequest.httpMethod = "POST"
        let input: [String: Any] = ["account": publicKey,"password": password]
        let json: Data
        do {
            json = try JSONSerialization.data(withJSONObject: input, options: [])
            urlRequest.httpBody = json
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: self, // DO NOT FORGET YOUR OBJECT HERE!!
            delegateQueue: nil)
        print("up to here")
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedPub = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                    else {
                        print("Could not get JSON from responseData as dictionary")
                        return
                }
                
                guard let token = receivedPub["token"] as? String else {
                    print("cannot login")
                    return
                }
                self.defaults.set(token, forKey: "token")
                print("The token is:"+(self.defaults.string(forKey: "token") ?? "not found"))
                SBDMain.connect(withUserId: publicKey) { (user, error) in
                    guard error == nil else {   // Error.
                        return
                    }
                }

                DispatchQueue.main.async {
                    let nav = self.storyboard?.instantiateViewController(withIdentifier: "nav")
                    self.present(nav!, animated: true, completion: nil)
                }

            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }

    

}

