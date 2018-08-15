//
//  SMCONSerialization.swift
//  SpreadMe
//
//  Created by Ilia Nikolaenko on 11/9/17.
//  Copyright © 2017 Ilia Nikolaenko. All rights reserved.
//

import UIKit

extension UInt16 {
    func characterRepresentation() -> Character {
        if let unicodescalar = UnicodeScalar(self) {
            let character = Character(unicodescalar)
            return character
        }
        return Character(UnicodeScalar(0))
    }
}

class SMCONSerialization: NSObject {
    static func contactObject(with string: String) -> SMContact? {
        guard string.count > 4 else {
            return nil
        }
        
        var lastIndex = string.startIndex
        let typeRawValue = String(string[lastIndex])
        //TODO: Fix it
        let type: SMContactType = typeRawValue == "p" ? .person : .organization
        
        lastIndex = string.index(lastIndex, offsetBy: 1)
        let nameCount = String.IndexDistance(string[lastIndex].unicodeScalars.first!.value)
        
        lastIndex = string.index(lastIndex, offsetBy: 1)
        let familyNameCount = String.IndexDistance(string[lastIndex].unicodeScalars.first!.value)
        
        lastIndex = string.index(lastIndex, offsetBy: 1)
        let phoneCount = String.IndexDistance(string[lastIndex].unicodeScalars.first!.value)
        
        let expectingLenght = lastIndex.encodedOffset + 1 + nameCount + familyNameCount + phoneCount
        
        guard  expectingLenght == string.count else {
            return nil
        }
        
        var start = string.index(lastIndex, offsetBy:1)
        var end = string.index(start, offsetBy: nameCount - 1)
        let name = (start < end) ? String(string[start...end]) : ""
        
        start = string.index(end, offsetBy: 1)
        end = string.index(start, offsetBy: familyNameCount - 1)
        let familyName = (start < end) ? String(string[start...end]) : ""

        start = string.index(end, offsetBy: 1)
        end = string.index(start, offsetBy: phoneCount - 1)
        let phone = (start < end) ? String(string[start...end]) : ""
        
        return SMContact(name: name, familyName: familyName, type: type, phone: phone)
    }
    
    static func string(withContactObject contact: SMContact) -> String {
        var string = String()
        string.append(contact.type.rawValue)
        string.append(UInt16(contact.name.count).characterRepresentation())
        string.append(UInt16(contact.familyName.count).characterRepresentation())
        string.append(UInt16(contact.phone.count).characterRepresentation())
        string.append(contact.name)
        string.append(contact.familyName)
        string.append(contact.phone)
        return string
    }
}
