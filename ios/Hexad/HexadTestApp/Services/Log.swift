//
//  Logs.swift
//  HexadTestApp
//
//  Created by di on 31.12.18.
//  Copyright © 2018 Ilia Nikolaenko. All rights reserved.
//

import Foundation

class Log {
    static func error(_ text: String) {
        print("‼️ \(text)")
    }
    
    static func warning(_ text: String) {
        print("❕ \(text)")
    }
}
