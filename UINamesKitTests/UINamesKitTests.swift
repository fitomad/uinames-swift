//
//  UINamesKitTests.swift
//  UINamesKitTests
//
//  Created by Adolfo Vera Blasco on 22/3/17.
//  Copyright © 2017 Adolfo Vera Blasco. All rights reserved.
//

import XCTest
@testable import UINamesKit

class UINamesKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPeople()
    {
        let expectation: XCTestExpectation = self.expectation(description: "People")
        
        UINamesClient.shared.people(amount: 430, extendedInformation: true, completionHandler: { (result: UINamesResult<[PersonExtended]>) -> (Void) in
            switch result
            {
                case let .success(people):
                    for person in people
                    {
                        dump(person)
                    }
                
                case let .error(message):
                    print("> \(message)")
            }
            
            expectation.fulfill()
        })
        
        self.waitForExpectations(timeout: 5000, handler: nil)
    }
    
    func testPerformancePerson() {
        self.measure
        {
            self.testPeople()
        }
    }
    
}
