//
//  SMCONSeriallizationTests.swift
//  SpreadMeTests
//
//  Created by Ilia Nikolaenko on 11/17/17.
//  Copyright © 2017 Ilia Nikolaenko. All rights reserved.
//

import XCTest

class SMCONSeriallizationTests: XCTestCase {
    
    func testPersonSeriallizationIsCorrect() {
        let contact = SMContact(name: "Name", familyName: "FamilyName", type: .person, phone: "+49 152 24061866")
        
        let result = SMCONSerialization.string(withContactObject: contact)
        
        XCTAssertEqual(result, "p\u{4}\n\u{10}NameFamilyName+49 152 24061866")
    }
    
    func testOrganizationSeriallizationIsCorrect() {
        let contact = SMContact(name: "My best company", familyName: "", type: .organization, phone: "+49 152 24061866")
        
        let result = SMCONSerialization.string(withContactObject: contact)
        
        XCTAssertEqual(result, "o\u{f}\0\u{10}My best company+49 152 24061866")
    }
    
    func testPersonDeseriallizationIsCorrect() {
        let contact = SMContact(name: "Name", familyName: "FamilyName", type: .person, phone: "+49 152 24061866")
        let string = "p\u{4}\n\u{10}NameFamilyName+49 152 24061866"
        
        let result = SMCONSerialization.contactObject(with: string)
        
        XCTAssertEqual(result, contact)
    }
    
    func testOrganizationDeseriallizationIsCorrect() {
        let contact = SMContact(name: "My best company", familyName: "", type: .organization, phone: "+49 152 24061866")
        let string = "o\u{f}\0\u{10}My best company+49 152 24061866"
        
        let result = SMCONSerialization.contactObject(with: string)
        
        XCTAssertEqual(result, contact)
    }
    
    func testWrongStringsNoCrashes() {
        XCTAssertNil(SMCONSerialization.contactObject(with: "p\u{4}\n\u{10}NameFamilyName+49152 24061866"))
        XCTAssertNil(SMCONSerialization.contactObject(with: "p\u{4}\n\u{10}NameFamilyame+49 152 24061866"))
        XCTAssertNil(SMCONSerialization.contactObject(with: "p\u{4}\n\u{10}NaameFamilyName+49 152 24061866"))
        XCTAssertNil(SMCONSerialization.contactObject(with: "NameFamilyName+49 152 24061866"))
    }
    
}
