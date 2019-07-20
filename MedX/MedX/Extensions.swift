//
//  Extensions.swift
//  MedX
//
//  Created by Griffin Shaw on 7/20/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
