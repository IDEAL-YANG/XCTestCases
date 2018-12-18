//
//  ListOrdersPresenter.swift
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

protocol ListOrdersPresentationLogic
{
  func presentSomething(response: ListOrders.Something.Response)
    
    func presentFetchedOrders(response: ListOrders.FetchOrders.Response)
}

class ListOrdersPresenter: ListOrdersPresentationLogic
{
  weak var viewController: ListOrdersDisplayLogic?
  
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter
    }()
    
  // MARK: Do something
  
  func presentSomething(response: ListOrders.Something.Response)
  {
    let viewModel = ListOrders.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
    
    func presentFetchedOrders(response: ListOrders.FetchOrders.Response) {
        
        let displayOrders = response.orders.map { (order) ->
            ListOrders.FetchOrders.ViewModel.DisplayedOrder in
            
            let display = ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: order.id, date: dateFormatter.string(from: order.date), email: order.email, name: order.firstName +  " " + order.lastName, total: currencyFormatter.string(from: order.total)!)
            return display
        }
        
        let viewModel = ListOrders.FetchOrders.ViewModel(displayedOrders: displayOrders)
        
        viewController?.displayFetchedOrders(viewModel: viewModel)
    }
    
}
