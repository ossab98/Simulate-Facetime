//
//  Simulate_FacetimeTests.swift
//  Simulate FacetimeTests
//
//  Created by Ossama Abdelwahab on 02/07/21.
//

import XCTest
@testable import Simulate_Facetime

class Simulate_FacetimeTests: XCTestCase {
    
    // MARK:- ContactsController
    func testContactsEmpty() throws {
        let controller = ContactsController()
        //controller.demoContacts()
        XCTAssertTrue(controller.contacts.isEmpty, "Array is Empty")
    }
    
    func testContactsNotEmpty() throws {
        let controller = ContactsController()
        controller.demoContacts()
        XCTAssertFalse(controller.contacts.isEmpty, "Array isn't Empty, Contacts count: \(controller.contacts.count)")
    }
    
    // MARK:- CameraManager
    func testCameraSupported() throws {
        if CameraManager.shared.isCameraSupported == true {
            XCTAssertTrue(CameraManager.shared.isCameraSupported, "Device has a camera")
        }else{
            XCTAssertFalse(CameraManager.shared.isCameraSupported, "Device hasn't a camera")
        }
    }
    
}
