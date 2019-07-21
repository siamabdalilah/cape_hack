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
    var api : LethAPI?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.5836969018, green: 0.7517433167, blue: 0.8807654977, alpha: 1)
        var key = sqliteOps.instance.readFromSQLite(table: "pub")
        print(key)
        if key != "" {
            publicKey.text = key
        }
        api = LethAPI()
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
        api!.signUp(password: password, completion: {response in
            do {
                guard let receivedPub = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                    else {
                        print("Could not get JSON from responseData as dictionary")
                        return
                }
                print(receivedPub.description)
                guard let key = receivedPub["account"] as? String else {
                    return
                }
                sqliteOps.instance.createTableInSQLite(tableName: "pub")
                sqliteOps.instance.prepareAndInsertToSQLite(table: "pub", field: "key", value: key)
                self.signInRequest(publicKey: sqliteOps.instance.readFromSQLite(table: "pub"), password: password)
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        })
    }
    func signInRequest(publicKey: String, password: String){
        api!.signIn(account: publicKey, password: password, completion: {response in
            do {
                guard let receivedPub = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String: Any]
                    else {
                        print("Could not get JSON from responseData as dictionary")
                        return
                }
                guard let token = receivedPub["token"] as? String else {
                    print("cannot login")
                    return
                }
                self.defaults.set(token, forKey: "token")
                SBDMain.connect(withUserId: publicKey) { (user, error) in
                    guard error == nil else {   // Error.
                        return
                    }
                }
                KeychainService.savePassword(service: "lightstream", account: publicKey, data: password)
                DispatchQueue.main.async {
                    let nav = self.storyboard?.instantiateViewController(withIdentifier: "nav")
                    self.present(nav!, animated: true, completion: nil)
                }
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        })
    }
    
    
    
}

