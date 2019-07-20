//
//  FilePicker.swift
//  MedX
//
//  Created by Siam Abd Al-Ilah on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import MobileCoreServices

class FilePicker: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func importFile(_ sender: Any) {
        pickFile()
    }
    
    func pickFile(){
        
        let documentTypes: [String] = [kUTTypeImage as String, kUTTypePDF as String]
        let documentPicker = UIDocumentPickerViewController(documentTypes: documentTypes, in: UIDocumentPickerMode.import)
        
        
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false // for now
        present(documentPicker, animated: true, completion: nil)
    }
}

extension FilePicker: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFilesUrl = urls.first else {
            // do nothing
            return
        }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxUrl = dir.appendingPathComponent(selectedFilesUrl.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxUrl.path) {
            print("Already exists")
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFilesUrl, to: sandboxUrl)
                print("copied file")
            } catch {
                print("Error")
            }
        }
        
        
    }
}



