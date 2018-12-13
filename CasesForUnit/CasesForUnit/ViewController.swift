//
//  ViewController.swift
//  CasesForUnit
//
//  Created by IDEAL YANG on 2018/12/13.
//  Copyright © 2018 IDEAL YANG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    public var counter:Counter = Counter(with: UserDefaults.standard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.countLabel.text = "\(counter.count)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCount(_:)), name: NSNotification.Name.CounterUpdate, object: nil)
    }

    @IBAction func minusCount(_ sender: Any) {
        counter.decrement()
        
    }
    
    @IBAction func incrementCount(_ sender: Any) {
        counter.increment()
        
    }
    
    @objc func updateCount(_ notification:Notification) {
        if let cer = notification.object as? Counter {
            self.countLabel.text = "\(cer.count)"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

