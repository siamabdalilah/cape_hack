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
    
    @IBAction func importFiles(_ sender: Any) {
        pickFile()
    }
    
    @IBOutlet weak var selectedFiles: UITableView! {
        didSet {
            selectedFiles.allowsSelection = false
            selectedFiles.delegate = self
//            selectedFiles.dataSource = files as UITableViewDataSource
        }
    }
    @IBOutlet weak var numFiles: UITextView!
    
    var files = [URL]() {
        didSet {
//            updateTable()
            numFiles.text = "Number of Files: \(String(files.count))"
        }
    }
    
    func updateTable(){
        
    }

    func pickFile(){
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
    func getFiles() -> [String:Data]{
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
