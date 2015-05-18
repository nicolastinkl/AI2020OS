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
    
    /*override func transitionFromViewController(fromViewController: UIViewController, toViewController: UIViewController, duration: NSTimeInterval, options: UIViewAnimationOptions, animations: () -> Void, completion: ((Bool) -> Void)?) {
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let menuViewController = !self.presenting ? screens.from as UIViewController : screens.to as UIViewController
        let bottomViewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let menuView = menuViewController.view
        let bottomView = bottomViewController.view
    }*/
    
}
