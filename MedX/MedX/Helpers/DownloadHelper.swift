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
    static func downloadWithMeta(meta: String, token: String, completion: @escaping (DataResponse<Any>)->()){
        let api = LethAPI()
        api.fetchFile(meta: meta, token: token, completion: {response in
            write(response: response, completion: completion)
        })
    }
    
    private static func write(response: DataResponse<Any>, completion: @escaping (DataResponse<Any>)->()){
        let url = FileManager.default.urls(for: .documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        let filePath = url.appendingPathComponent("randomfilename101hahahalol.txt")
        do {
            try response.data?.write(to: filePath)
            print("File written to disk")
        } catch {
            print("Error writing file. completion function not executed")
            return
        }
        completion(response)
    }
}


