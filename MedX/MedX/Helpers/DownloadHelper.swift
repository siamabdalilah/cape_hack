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
    private static func testDownload(){

//            downloadWithMeta(meta: "QmUFL1AsYXFg4hpj9wJfJJaPkLEmxTxz8NWVXabyoASAgY", token: "eyJibG9ja2NoYWluIjoiRVRIIiwiZXRoX2FkZHJlc3MiOiIweGM5MTZDZmU1YzgzZEQ0RkMzYzNCMEJmMmVjMmQ0ZTQwMTc4Mjg3NWUiLCJpYXQiOjE3NDQ5LCJlYXQiOjE4NDQ5fQ.5ldY8UNBeiGcf31LGvkZDrBq9lrU7OWxc9Ii0PdjwgNQMUNtgqwq0td10Yu47AjzHJArM0AhXbDFc9NqvxR-jwE", completion: {_ in print("done")})
    }
    
    static func download(files: [String: String], token: String, completion: @escaping (DataResponse<Any>)->()){
        let api = LethAPI()
        for (name, meta) in files {
            api.fetchFile(meta: meta, token: token, completion: {response in
                write(fileName: name, response: response, completion: completion)
            })
        }
        
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


