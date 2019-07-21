//
//  DownloadHelper.swift
//  MedX
//
//  Created by Siam Abd Al-Ilah on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import Alamofire

class DownloadHelper{

    static func download(files: [String: String], token: String, completion: @escaping (DataResponse<Any>)->()){
        let api = LethAPI()
        for (name, meta) in files {
            api.fetchFile(meta: meta, token: token, completion: {response in
                write(fileName: name, response: response, completion: completion)
            })
        }
    }
    static func download(files: [String: String], completion: @escaping (DataResponse<Any>)->()){
        download(files: files, token: UserDefaults.standard.string(forKey: "token")!, completion: completion)
    }
    
    static func fileExists(fileName: String) -> Bool {
        let pathUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: pathUrl.path)
    }
    
    private static func write(fileName: String, response: DataResponse<Any>, completion: @escaping (DataResponse<Any>)->()){
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName)
        do {
            print(filePath.absoluteString)
            try response.data?.write(to: filePath)
            print("\(fileName) written to disk")
        } catch {
            print("Error writing file: \(fileName). completion function not executed")
            return
        }
        completion(response)
    }
}


