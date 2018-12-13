//
//  Counter.swift
//  CasesForUnit
//
//  Created by IDEAL YANG on 2018/12/13.
//  Copyright © 2018 IDEAL YANG. All rights reserved.
//

import UIKit

extension NSNotification.Name {
    
    @available(iOS 8.0, *)
    public static let CounterUpdate: NSNotification.Name = NSNotification.Name(rawValue: "CounterUpdate")
}

public class Counter: NSObject {
    
    public var count:Int = 0
    private var defaults:UserDefaults
    
    public init(with userDefaults:UserDefaults) {
        defaults = userDefaults
        super.init()
        count = getCountInDefaults()
    }
    
    public func increment() {
        count = getCountInDefaults() + 1
        defaults.set(count, forKey: countInDefaultID)
        NotificationCenter.default.post(name: NSNotification.Name.CounterUpdate, object: self)
    }
    
    public func decrement() {
        count = getCountInDefaults() - 1
        defaults.set(count, forKey: countInDefaultID)
        NotificationCenter.default.post(name: NSNotification.Name.CounterUpdate, object: self)
    }
    
    private let countInDefaultID:String = "countInDefaultID"
    
    public func getCountInDefaults() -> Int {
        var reminderId = defaults.object(forKey: countInDefaultID)
        if let remindId = reminderId as? NSNumber {
            reminderId = remindId
        }else {
            reminderId = NSNumber.init(value: 0)
        }
        return (reminderId as! NSNumber).intValue
    }
    
}
