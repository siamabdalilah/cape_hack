//
//  FilePickerViewController.swift
//  MedX
//
//  Created by Siam Abd Al-Ilah on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import MobileCoreServices

class FilePickerViewController: UIViewController {
    private let types: [String: String] = [
        "json": "application/json",
        "pdf":  "application/pdf",
        "jpg":  "image/jpeg",
        "png":  "image/png",
        "txt":  "text/plain"
    ]
    
    
    @IBAction func importFiles(_ sender: Any) {
        pickFile()
    }
    
    @IBAction func uploadSelectedFiles(_ sender: Any) {
        checkUploadability()
        
        let api = LethAPI()
        api.signUp(password: "pass123")
        api.signIn(account: "0xc916cfe5c83dd4fc3c3b0bf2ec2d4e401782875e", password: "WelcomeToSirius")
        
        let filesToUpload = getFiles()
        
        for (name, data) in filesToUpload {
            let ext = String(name.split(separator: ".").last ?? "")
            if let mimeType = types[ext] {
                //api.addFile(name: name, type: mimeType, data: data)
                print(String(decoding: data, as: UTF8.self))
                print("file uploaded")
            } else {
                // TODO
            }
            
        }
    }
    
    @IBOutlet weak var selectedFiles: UITableView! {
        didSet {
            selectedFiles.allowsSelection = false
            selectedFiles.delegate = self
        }
    }
    @IBOutlet weak var numFiles: UITextView!
    
    private var files = [URL]() {
        didSet {
            numFiles.text = "Number of Files: \(String(files.count))"
        }
    }
  
    private func checkUploadability(){
        // TODO
    }

    private func pickFile(){
        let s = "sdsdscsdcsdc"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("hello.txt")
        do{
            try s.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        }
        catch{
            return
        }

        let documentTypes: [String] = [kUTTypeImage as String, kUTTypePDF as String, kUTTypeText as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: UIDocumentPickerMode.import)
        
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true //false // for now
        present(documentPicker, animated: true, completion: nil)
    }
    
    // returns [String: Data] dictionaries with names and file for all URLs in selected
    private func getFiles() -> [String:Data]{
        var returnVal = [String:Data]()
        for file in files{
            let data = FileManager.default.contents(atPath: file.path) ?? "Error: Unable to get file".data(using: String.Encoding.utf8)
            returnVal[file.path] = data
        }
        
        return returnVal
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilePickerViewController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if (urls.isEmpty) {
            return
        }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        for url in urls {
            let sandboxUrl = dir.appendingPathComponent(url.lastPathComponent)
            print(sandboxUrl.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: sandboxUrl.path) {
                print("Already exists")
            } else {
                do {
                    try FileManager.default.copyItem(at: url, to: sandboxUrl)
                    print("copied file")
                } catch {
                    print("Error")
                }
            }
            
            self.files.append(sandboxUrl)
        }
    }
}

extension FilePickerViewController: UITableViewDelegate{
    func tableView(table: UITableView, willDisplay: UITableViewCell, forRowAt: IndexPath){
//        willDisplay.textLabel = table.dataSource!.
    }

}
