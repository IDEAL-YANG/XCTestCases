//
//  CreateOrderViewController.swift
//  CleanStore
//
//  Created by IDEAL YANG on 2018/12/14.
//  Copyright (c) 2018 IDEAL YANG. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CreateOrderDisplayLogic: class
{
  func displaySomething(viewModel: CreateOrder.Something.ViewModel)
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
}

public class CreateOrderViewController: UITableViewController, CreateOrderDisplayLogic
{

  var interactor: CreateOrderBusinessLogic?
  var router: (NSObjectProtocol & CreateOrderRoutingLogic & CreateOrderDataPassing)?

    // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = CreateOrderInteractor()
    let presenter = CreateOrderPresenter()
    let router = CreateOrderRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
    override public func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
    configurePickers()
  }
  
  // MARK: Do something
    func doSomething()
    {
        let request = CreateOrder.Something.Request()
        interactor?.doSomething(request: request)
    }
    
  //@IBOutlet weak var nameTextField: UITextField!
    
    // MARK: Text fields
    @IBOutlet var textFields: [UITextField]!
    
    // MARK: Shipping method
    @IBOutlet weak var shippingMethodTextField: UITextField!
    @IBOutlet var shippingMethodPicker: UIPickerView!
    
    // MARK: Expiration date
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet var expirationDatePicker: UIDatePicker!
    
    @IBAction func expirationDatePickerValueChanged(_ sender: Any) {
        let date = expirationDatePicker.date
        let request = CreateOrder.FormatExpirationDate.Request(date: date)
        interactor?.formatExpirationDate(request: request)
    }
    
    func configurePickers()
    {
        shippingMethodTextField.inputView = shippingMethodPicker
        expirationDateTextField.inputView = expirationDatePicker
    }
}

extension CreateOrderViewController {
    
    func displaySomething(viewModel: CreateOrder.Something.ViewModel)
    {
        //nameTextField.text = viewModel.name
    }
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel) {
        expirationDateTextField.text = viewModel.date
    }
}

extension CreateOrderViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let index = textFields.firstIndex(of: textField) {
            if index < textFields.count - 1 {
                let nextTextField = textFields[index + 1]
                let resu = nextTextField.becomeFirstResponder()
            }
        }
        return true
    }

}

extension CreateOrderViewController {
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            for textField in textFields {
                if textField.isDescendant(of: cell) {
                    textField.becomeFirstResponder()
                }
            }
        }
    }

}

extension CreateOrderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return (interactor?.shippingMethods.count)!
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interactor?.shippingMethods[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shippingMethodTextField.text = interactor?.shippingMethods[row]
    }
    
}
