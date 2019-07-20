//
//  ViewController.swift
//  MedX
//
//  Created by user on 7/19/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import SQLite3
class ViewController: UIViewController, URLSessionDelegate {
    var db : OpaquePointer?
    
    @IBOutlet weak var publicKey: UITextField!
    @IBOutlet weak var password: UITextField!
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = #colorLiteral(red: 0.5836969018, green: 0.7517433167, blue: 0.8807654977, alpha: 1)
        db = openDatabase()
        if db != nil {
            var key = readFromSQLite(table: "pub")
            if key != "" {
                publicKey.text = key
            }
            
        }

    }
    
    @IBAction func signUp(sender: UIButton) {
        if db != nil {
            //makeRequest(value: password.text!)
            
            
        }
    }
    
    //    @IBAction func open(_ sender: UIButton) {
//        db = openDatabase()
//    }
//
//    @IBAction func insert(_ sender: UIButton) {
//        self.prepareAndInsertToSQLite(table: "pub", field: "key", value: "newFoo")
//    }
//
//    @IBAction func read(_ sender: UIButton) {
//        readFromSQLite()
//    }
//    @IBAction func request(_ sender: UIButton) {
//        makeRequest()
//    }
//    @IBAction func deleteRow(_ sender: UIButton) {
//        deleteFromSQLite(table: "pub", value: "foo")
//    }
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("test.sqlite")
        
        // open database
        
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("success opening database")
            return db
        }else{
            print("error opening database")
            return nil
        }
        
    }
    func createTableInSQLite(tableName: String){
        if sqlite3_exec(db, "create table if not exists \(tableName) (key text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }else{
            print("create table success")
        }
    }
    func prepareAndInsertToSQLite(table: String, field: String, value: String){
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into \(table) (\(field)) values (?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }else{
            print("success preparing insert")
        }
        if sqlite3_bind_text(statement, 1, value, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }else{
            print("success binding foo")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        }else{
            print("success inserting foo")
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }else{
            print("success finalizing prepared statement")
        }
        statement = nil
    }
    func readFromSQLite(table: String) -> String{
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "select key from \(table)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        var key = ""
        if table == "pub" {
            while sqlite3_step(statement) == SQLITE_ROW {
                
                if let cString = sqlite3_column_text(statement, 0) {
                    key = String(cString: cString)
                } else {
                    print("key not found")
                }
            }
        }
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        db = nil
        return key
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    func signUpRequest(value: String){
        let endpoint: String = "https://ec2-18-222-226-162.us-east-2.compute.amazonaws.com:8080/user/signup"
        guard let createUrl = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: createUrl)
        urlRequest.httpMethod = "POST"
        let input: [String: Any] = ["password": password.text!]
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
                guard let key = receivedPub["account"] as? String else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The key is: \(key)")
                self.prepareAndInsertToSQLite(table: "pub", field: "key", value: key)
                
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
    
    func fetchFile(meta: String, token: String) {
        let endpoint: String = "https://ec2-18-222-226-162.us-east-2.compute.amazonaws.com:8080/storage/fetch"
        let meta1 = "QmcGHK3Ye5axzsN5dKJfSz6JbPLqrvx88d31vUyKuSNoSK"
        // Becomes invalid eventually
        let token1 = "eyJibG9ja2NoYWluIjoiRVRIIiwiZXRoX2FkZHJlc3MiOiIweGM5MTZDZmU1YzgzZEQ0RkMzYzNCMEJmMmVjMmQ0ZTQwMTc4Mjg3NWUiLCJpYXQiOjEwMDQ2LCJlYXQiOjExMDQ2fQ.X86hAba2Fz759fOJwRZYUHYebG9uCTRwwN4dtG1L9HNU3AdJ0d5lh6CsJrurTxTtKUb8Z8mteLter16VIf2DnAE"
        guard let createUrl = URL(string: endpoint + "?meta=" + meta1 + "&token=" + token1) else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: createUrl)
        urlRequest.httpMethod = "GET"
        let input: [String: Any] = ["password": password.text!]
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
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any]
                print(json!)
            }
            catch {
                return
            }
        }
        task.resume()
    }
    
    func deleteFromSQLite(table: String,value: String){
        let statementString = "DELETE FROM \(table) WHERE key = ?;"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, statementString, -1, &statement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(statement, 1, value, -1, SQLITE_TRANSIENT)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(statement)
    }
    

}

