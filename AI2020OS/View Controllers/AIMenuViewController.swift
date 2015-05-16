//
//  AIMenuViewController.swift
//  AI2020OS
//
//  Created by tinkl on 16/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIMenuViewController: UIViewController {
    
    @IBOutlet weak var menuHomeButton: UIButton!
    @IBOutlet weak var menuMessageButton: UIButton!
    @IBOutlet weak var menuSettingsButton: UIButton!

    // MARK: view lifecricle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuHomeButton.maskWithEllipse()
        self.menuMessageButton.maskWithEllipse()
        self.menuSettingsButton.maskWithEllipse()
        
    }
    
    // MARK: action
    
    @IBAction func showSettings(sender: AnyObject) {
        
    }
    
    @IBAction func showMessage(sender: AnyObject) {
        
    }
    
    @IBAction func showHome(sender: AnyObject) {
        
    }
    
     // MARK: animation with viewCotroller
    
    //重写动画
    override func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
        
    }
    
    // TODO: and
    
    
    
    // FIXME:
}