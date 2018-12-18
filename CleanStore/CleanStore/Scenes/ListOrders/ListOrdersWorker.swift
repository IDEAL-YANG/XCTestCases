//
//  ListOrdersWorker.swift
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

protocol OrdersStoreProtocol
{
    func fetchOrders(completionHandler: @escaping (_ orders: [Order]) -> Void)
}

class ListOrdersWorker
{
    
    var ordersStore: OrdersStoreProtocol
    
    init(ordersStore: OrdersStoreProtocol)
    {
        self.ordersStore = ordersStore
    }
    
  func doSomeWork()
  {
  }
    
    func fetchOrders(completionHandler: @escaping (_ orders: [Order]) -> Void)
    {
        ordersStore.fetchOrders { (orders) in
            completionHandler(orders)
        }
    }
    
}