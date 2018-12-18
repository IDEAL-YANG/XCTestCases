//
//  ListOrdersPresenterTests.swift
//  CleanStore
//
//  Created by IDEAL YANG on 2018/12/17.
//  Copyright (c) 2018 IDEAL YANG. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import CleanStore
import XCTest

class ListOrdersPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: ListOrdersPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupListOrdersPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupListOrdersPresenter()
  {
    sut = ListOrdersPresenter()
  }
  
  // MARK: Test doubles
  
  class ListOrdersDisplayLogicSpy: ListOrdersDisplayLogic
  {
    var displaySomethingCalled = false
    
    func displaySomething(viewModel: ListOrders.Something.ViewModel)
    {
      displaySomethingCalled = true
    }
    
    // MARK: Method call expectations
    var displayFetchedOrdersCalled = false
    
    // MARK: Argument expectations
    var listOrders_fetchOrders_viewModel: ListOrders.FetchOrders.ViewModel!
    
    // MARK: Spied methods
    func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel)
    {
        displayFetchedOrdersCalled = true
        listOrders_fetchOrders_viewModel = viewModel
    }
    
  }
  
  // MARK: Tests
  
  func testPresentSomething()
  {
    // Given
    let spy = ListOrdersDisplayLogicSpy()
    sut.viewController = spy
    let response = ListOrders.Something.Response()
    
    // When
    sut.presentSomething(response: response)
    
    // Then
    XCTAssertTrue(spy.displaySomethingCalled, "presentSomething(response:) should ask the view controller to display the result")
  }
    
    func testPresentFetchedOrdersShouldFormatFetchedOrdersForDisplay()
    {
        // Given
        let listOrdersPresenterOutputSpy = ListOrdersDisplayLogicSpy()
        sut.viewController = listOrdersPresenterOutputSpy
        
        var dateComponents = DateComponents()
        dateComponents.year = 2007
        dateComponents.month = 6
        dateComponents.day = 29
        let date = NSCalendar.current.date(from: dateComponents)!
        
        let orders = [Order(id: "abc123", date: date, email: "amy.apple@clean-swift.com", firstName: "Amy", lastName: "Apple", total: NSDecimalNumber(string: "1000.23"))]
        let response = ListOrders.FetchOrders.Response(orders: orders)
        
        // When
        sut.presentFetchedOrders(response: response)
        
        // Then
        let displayedOrders = listOrdersPresenterOutputSpy.listOrders_fetchOrders_viewModel.displayedOrders
        for displayedOrder in displayedOrders{
            XCTAssertEqual(displayedOrder.id, "abc123", "Presenting fetched orders should properly format order ID")
            XCTAssertEqual(displayedOrder.date, "6/29/07", "Presenting fetched orders should properly format order date")
            XCTAssertEqual(displayedOrder.email, "amy.apple@clean-swift.com", "Presenting fetched orders should properly format email")
            XCTAssertEqual(displayedOrder.name, "Amy Apple", "Presenting fetched orders should properly format name")
            XCTAssertEqual(displayedOrder.total, "$1,000.23", "Presenting fetched orders should properly format total")
        }
    }
    
    func testPresentFetchedOrdersShouldAskViewControllerToDisplayFetchedOrders()
    {
        // Given
        let listOrdersPresenterOutputSpy = ListOrdersDisplayLogicSpy()
        sut.viewController = listOrdersPresenterOutputSpy
        
        let orders = [Order(id: "abc123", date: Date(), email: "amy.apple@clean-swift.com", firstName: "Amy", lastName: "Apple", total: NSDecimalNumber(string: "1.23"))]
        let response = ListOrders.FetchOrders.Response(orders: orders)
        
        // When
        sut.presentFetchedOrders(response:response)
        
        // Then
        XCTAssert(listOrdersPresenterOutputSpy.displayFetchedOrdersCalled, "Presenting fetched orders should ask view controller to display them")
    }
    
}
