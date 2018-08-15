//
//  SMContact.swift
//  SpreadMe
//
//  Created by Ilia Nikolaenko on 11/9/17.
//  Copyright © 2017 Ilia Nikolaenko. All rights reserved.
//

import Contacts

struct SMContact {
    let name: String
    let familyName: String
    let type: SMContactType
    let phone: String
}

enum SMContactType: Character {
    case organization = "o"
    case person = "p"
}

extension SMContact {
    init(contact: CNContact) {
        switch contact.contactType {
        case .organization:
            self.type = .organization
            self.name = contact.organizationName.count > 0 ? contact.organizationName : " "
            self.familyName = " "
        case .person:
            self.type = .person
            self.name = contact.givenName.count > 0 ? contact.givenName : " "
            self.familyName = contact.familyName.count > 0 ? contact.familyName : " "
        }
        
        if let phone = contact.phoneNumbers.first {
            self.phone = phone.value.stringValue.count > 0 ? phone.value.stringValue : " "
        } else {
            self.phone = " "
        }
    }
    
    func cnContact() -> CNContact {
        let contact = CNMutableContact()
        contact.familyName = self.familyName
        contact.givenName = self.name
        
        let phoneNumber = CNPhoneNumber(stringValue: self.phone)
        let phone = CNLabeledValue(label: nil, value: phoneNumber)
        contact.phoneNumbers = [phone]
        
        return contact.copy() as! CNContact
    }
}

extension SMContact: Equatable {
    public static func ==(lhs: SMContact, rhs: SMContact) -> Bool {
        return ((lhs.name == rhs.name) &&  (lhs.familyName == rhs.familyName) &&  (lhs.type == rhs.type) && (lhs.phone == rhs.phone))
    }
}

