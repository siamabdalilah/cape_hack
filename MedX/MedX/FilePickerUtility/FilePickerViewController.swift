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
        if (!checkUploadability()){
            // todo: wentao
            return
        }
        updateDatabase()
        
        let api = LethAPI()
        
        let filesToUpload = filesDict
        
        for (name, data) in filesToUpload {
            let ext = String(name.split(separator: ".").last ?? "")
            if let mimeType = types[ext] {
                print("Name of file \(name)")
                print("data:")
                print(String(decoding: data, as: UTF8.self))
                api.addFile(name: name, type: mimeType, data: data, completion: {response in print("File Uploaded")})
//                print(String(decoding: data, as: UTF8.self))
//                print("file uploaded")
            } else {
                // TODO
            }
            
        }
    }
    
    @IBOutlet weak var selectedFiles: UITableView! {
        didSet {
            selectedFiles.allowsSelection = false
            selectedFiles.delegate = self
            selectedFiles.dataSource = self
        }
    }
    @IBOutlet weak var numFiles: UITextView!
    
    private var filesDict = [String: Data]() {
        didSet {
            numFiles.text = "Number of Files: \(String(filesDict.count))"
        }
    }
  
    private func checkUploadability() -> Bool{
        // TODO: wentao
        return true
    }
    private func updateDatabase(){
        // todo: wentao
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

        let documentTypes: [String] = [kUTTypeImage as String, kUTTypePDF as String, kUTTypeText as String, kUTTypeJSON as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: UIDocumentPickerMode.import)
        
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true //false // for now
        present(documentPicker, animated: true, completion: nil)
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
            let data = FileManager.default.contents(atPath: url.path) ?? "Error: Unable to get file".data(using: String.Encoding.utf8)
            self.filesDict[url.lastPathComponent] = data
            
        }
    }
}

extension FilePickerViewController: UITableViewDelegate{
   
}

extension FilePickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filesDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style:.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "PLACEHOLDER)"
        return cell
    }
}



