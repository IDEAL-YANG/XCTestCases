//
//  CasesForUnitTests.swift
//  CasesForUnitTests
//
//  Created by IDEAL YANG on 2018/12/13.
//  Copyright © 2018 IDEAL YANG. All rights reserved.
//

import XCTest
@testable import CasesForUnit

class CasesForUnitTests: XCTestCase {
    
    var sut:Counter!
    var mockDefaults:UserDefaults!
    
    private var modelChangedCount:Int = 0
    private var modelChangedValue:Int!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockDefaults = UserDefaults.init(suiteName: "CounterMock")
        sut = Counter.init(with: mockDefaults!)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("CounterUpdate"), object: sut, queue: nil) { (notification) in
            self.modelChangedCount += 1
            if let counter = notification.object as? Counter {
                self.modelChangedValue = counter.count
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mockDefaults = nil
        sut = nil
        NotificationCenter.default.removeObserver(self)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension CasesForUnitTests {
    
    func testInitShouldNotReturnNil() {
        let counter = Counter.init(with: mockDefaults)
        XCTAssert(counter.isMember(of: Counter.self))
    }
    
    func testGetCountInDefaultsWithNilShouldReturnZero() {
        mockDefaults.setValue(nil, forKey: "countInDefaultID")
        XCTAssertEqual(sut.getCountInDefaults(), 0)
    }
    
    func testGetCountInDefaultsWithNumberThreeShouldReturnIntThree() {
        mockDefaults.setValue(NSNumber.init(value: 3), forKey: "countInDefaultID")
        XCTAssertEqual(sut.getCountInDefaults(), 3)
    }
    
    func testIncrementShouldInvokeSetObject() {
        mockDefaults.setValue(NSNumber.init(value: 3), forKey: "countInDefaultID")
        sut.increment()
        XCTAssertEqual(sut.getCountInDefaults(), 4)
    }
    
    func testIncrementShouldPostNotification() {
        mockDefaults.setValue(NSNumber.init(value: 3), forKey: "countInDefaultID")
        sut.increment()
        sut.increment()
        XCTAssertEqual(modelChangedCount, 2)
        XCTAssertEqual(modelChangedValue, 5)
    }
    
    func testDecrementShouldInvokeSetObject() {
        mockDefaults.setValue(NSNumber.init(value: 3), forKey: "countInDefaultID")
        sut.decrement()
        XCTAssertEqual(sut.getCountInDefaults(), 2)
    }
    
    func testDecrementShouldPostNotification() {
        mockDefaults.setValue(NSNumber.init(value: 3), forKey: "countInDefaultID")
        sut.decrement()
        sut.decrement()
        XCTAssertEqual(modelChangedCount, 2)
        XCTAssertEqual(modelChangedValue, 1)
    }
    
}

