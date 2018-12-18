//
//  CreateOrderViewControllerTests.swift
//  CleanStore
//
//  Created by IDEAL YANG on 2018/12/14.
//  Copyright (c) 2018 IDEAL YANG. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import CleanStore
import XCTest

class CreateOrderViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: CreateOrderViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupCreateOrderViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupCreateOrderViewController(){
    let bundle = Bundle.init(for: type(of: self))
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "CreateOrderViewController") as! CreateOrderViewController
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class CreateOrderBusinessLogicSpy: CreateOrderBusinessLogic
  {
    var shippingMethods: [String] = []
    
    // MARK: Argument expectations
    var createOrder_formatExpirationDate_request: CreateOrder.FormatExpirationDate.Request!
    
    var formatExpirationDateCalled = false
    
    func formatExpirationDate(request: CreateOrder.FormatExpirationDate.Request) {
        formatExpirationDateCalled = true
        createOrder_formatExpirationDate_request = request
    }
    
    var doSomethingCalled = false
    
    func doSomething(request: CreateOrder.Something.Request)
    {
      doSomethingCalled = true
    }
  }
  
  // MARK: Tests
  
  func testShouldDoSomethingWhenViewIsLoaded()
  {
    // Given
    let spy = CreateOrderBusinessLogicSpy()
    sut.interactor = spy
    
    // When
    loadView()
    
    // Then
    XCTAssertTrue(spy.doSomethingCalled, "viewDidLoad() should ask the interactor to do something")
  }
  
  func testDisplaySomething()
  {
    // Given
    let viewModel = CreateOrder.Something.ViewModel()
    
    // When
    sut.displaySomething(viewModel: viewModel)
    
    // Then
//    XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
  }
    
    func testDisplayExpirationDateShouldDisplayDateStringInTextField()
    {
        // Given
        loadView()
        let viewModel = CreateOrder.FormatExpirationDate.ViewModel(date: "6/29/07")
        
        // When
        sut.displayExpirationDate(viewModel: viewModel)
        
        // Then
        let displayedDate = sut.expirationDateTextField.text
        XCTAssertEqual(displayedDate, "6/29/07", "Displaying an expiration date should display the date string in the expiration date text field")
    }
    
    func testExpirationDatePickerValueChangedShouldFormatSelectedDate()
    {
        // Given
        let createOrderViewControllerOutputSpy = CreateOrderBusinessLogicSpy()
        sut.interactor = createOrderViewControllerOutputSpy
        
        var dateComponents = DateComponents()
        dateComponents.year = 2007
        dateComponents.month = 6
        dateComponents.day = 29
        let selectedDate = NSCalendar.current.date(from: dateComponents)!
        
        // When
        sut.expirationDatePicker.date = selectedDate
        sut.expirationDatePickerValueChanged(self)
        
        // Then
        XCTAssert(createOrderViewControllerOutputSpy.formatExpirationDateCalled, "Changing the expiration date should format the expiration date")
        let actualDate = createOrderViewControllerOutputSpy.createOrder_formatExpirationDate_request.date
        XCTAssertEqual(actualDate, selectedDate, "Changing the expiration date should format the date selected in the date picker")
    }
    
    func testNumberOfComponentsInPickerViewShouldReturnOneComponent()
    {
        // Given
        let pickerView = sut.shippingMethodPicker
        
        // When
        let numberOfComponents = sut.numberOfComponents(in: pickerView!)
        
        // Then
        XCTAssertEqual(numberOfComponents, 1, "The number of components in the shipping method picker should be 1")
    }
    
    func testNumberOfRowsInFirstComponentOfPickerViewShouldEqualNumberOfAvailableShippingMethods()
    {
        // Given
        let pickerView = sut.shippingMethodPicker
        
        // When
        let numberOfRows = sut.pickerView(pickerView!, numberOfRowsInComponent: 0)
        
        // Then
        let numberOfAvailableShippingtMethods = sut.interactor!.shippingMethods.count
        XCTAssertEqual(numberOfRows, numberOfAvailableShippingtMethods, "The number of rows in the first component of shipping method picker should equal to the number of available shipping methods")
    }
    
    func testShippingMethodPickerShouldDisplayProperTitles()
    {
        // Given
        let pickerView = sut.shippingMethodPicker
        
        // When
        let returnedTitles = [
            sut.pickerView(pickerView!, titleForRow: 0, forComponent: 0),
            sut.pickerView(pickerView!, titleForRow: 1, forComponent: 0),
            sut.pickerView(pickerView!, titleForRow: 2, forComponent: 0)
        ]
        
        // Then
        var expectedTitles = [
            "Standard Shipping",
            "Two-Day Shipping",
            "One-Day Shipping"
        ]
        XCTAssertEqual(returnedTitles[0], expectedTitles[0], "The shipping method picker should display proper titles")
        XCTAssertEqual(returnedTitles[1], expectedTitles[1], "The shipping method picker should display proper titles")
        XCTAssertEqual(returnedTitles[2], expectedTitles[2], "The shipping method picker should display proper titles")
    }
    
    func testSelectingShippingMethodInThePickerShouldDisplayTheSelectedShippingMethodToUser()
    {
        // Given
        loadView()
        let pickerView = sut.shippingMethodPicker
        
        // When
        sut.pickerView(pickerView!, didSelectRow: 1, inComponent: 0)
        
        // Then
        let expectedShippingMethod = "Two-Day Shipping"
        let displayedShippingMethod = sut.shippingMethodTextField.text
        XCTAssertEqual(displayedShippingMethod, expectedShippingMethod, "Selecting a shipping method in the shipping method picker should display the selected shipping method to the user")
    }
    
    func testCursorFocusShouldMoveToNextTextFieldWhenUserTapsReturnKey()
    {
        // Given
        loadView()
        
        let currentTextField = sut.textFields[0]
        let nextTextField = sut.textFields[1]
        currentTextField.becomeFirstResponder()
        
        // When
        _ = sut.textFieldShouldReturn(currentTextField)
        
        // Then
        XCTAssert(!currentTextField.isFirstResponder, "Current text field should lose keyboard focus")
        XCTAssert(!nextTextField.isFirstResponder, "Next text field should gain keyboard focus")
    }
    
    func testKeyboardShouldBeDismissedWhenUserTapsReturnKeyWhenFocusIsInLastTextField()
    {
        // Given
        loadView()
        
        // Scroll to the bottom of table view so the last text field is visible and its gesture recognizer is set up
        let lastSectionIndex = sut.tableView.numberOfSections - 1
        let lastRowIndex = sut.tableView.numberOfRows(inSection: lastSectionIndex) - 1
        sut.tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: false)
        
        // Show keyboard for the last text field
        let numTextFields = sut.textFields.count
        let lastTextField = sut.textFields[numTextFields - 1]
        lastTextField.becomeFirstResponder()
        
        // When
        _ = sut.textFieldShouldReturn(lastTextField)
        
        // Then
        XCTAssert(!lastTextField.isFirstResponder, "Last text field should lose keyboard focus")
    }
    
    func testTextFieldShouldHaveFocusWhenUserTapsOnTableViewRow()
    {
        // Given
        loadView()
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        
        // Then
        let textField = sut.textFields[0]
        XCTAssert(textField.isFirstResponder, "The text field should have keyboard focus when user taps on the corresponding table view row")
    }
    
    func testCreateOrderViewControllerShouldConfigurePickersWhenViewIsLoaded()
    {
        // Given
        loadView()
        // When
        
        // Then
        XCTAssertEqual(sut.expirationDateTextField.inputView, sut.expirationDatePicker, "Expiration date text field should have the expiration date picker as input view")
        XCTAssertEqual(sut.shippingMethodTextField.inputView, sut.shippingMethodPicker, "Shipping method text field should have the shipping method picker as input view")
    }
    
}