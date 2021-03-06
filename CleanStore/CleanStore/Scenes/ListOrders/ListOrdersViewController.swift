//
//  ListOrdersViewController.swift
//  CleanStore
//
//  Created by IDEAL YANG on 2018/12/17.
//  Copyright (c) 2018 IDEAL YANG. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListOrdersDisplayLogic: class
{
  func displaySomething(viewModel: ListOrders.Something.ViewModel)
    
    func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel)
}

public class ListOrdersViewController: UITableViewController, ListOrdersDisplayLogic
{
  var interactor: ListOrdersBusinessLogic?
  var router: (NSObjectProtocol & ListOrdersRoutingLogic & ListOrdersDataPassing)?

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
    let interactor = ListOrdersInteractor()
    let presenter = ListOrdersPresenter()
    let router = ListOrdersRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  public override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  public override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
    fetchOrdersOnLoad()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = ListOrders.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: ListOrders.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    func fetchOrdersOnLoad() {
        let request = ListOrders.FetchOrders.Request()
        interactor?.fetchOrders(request: request)
    }
    
    var displayedOrders:[ListOrders.FetchOrders.ViewModel.DisplayedOrder] = []
    
    func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel) {
        
        displayedOrders = viewModel.displayedOrders
        tableView.reloadData()
    }
    
}

extension ListOrdersViewController {
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell")
        cell?.textLabel?.text = displayedOrders[indexPath.row].date
        cell?.detailTextLabel?.text = displayedOrders[indexPath.row].total
        return cell!
    }
    
}
