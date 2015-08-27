//
//  AIMenuViewController.swift
//  AI2020OS
//
//  Created by tinkl on 16/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIMenuViewController: UIViewController {
    
    // MARK: swift controls
    
    @IBOutlet weak var menuHomeButton: SpringButton!
    @IBOutlet weak var menuMessageButton: SpringButton!
    @IBOutlet weak var menuSettingsButton: SpringButton!

    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuHomeButton.maskWithEllipse()
        self.menuMessageButton.maskWithEllipse()
        self.menuSettingsButton.maskWithEllipse()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)         
        
        self.menuHomeButton.animation = "zoomOut"
        self.menuMessageButton.animation = "zoomOut"
        self.menuSettingsButton.animation = "zoomOut"
        
        self.menuHomeButton.animate()
        self.menuMessageButton.animate()
        self.menuSettingsButton.animate()
    }
    
    // MARK: event response
    
    
    @IBAction func showSettings(sender: AnyObject) {
        
        
 /*
        self.dismissViewControllerAnimated(true, completion: {
            let viewNavi = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AISettingsStoryboard, bundle: nil).instantiateInitialViewController() as UIViewController
            let rootViewConrooler = UIApplication.sharedApplication().keyWindow?.rootViewController
            rootViewConrooler?.showViewController(viewNavi, sender: nil)
        })
   */     
    }
    
    @IBAction func showMessage(sender: AnyObject) {
         //        self.dismissViewControllerAnimated(true, completion: {
//            let storyBoard:UIStoryboard = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIMesageCenterStoryboard, bundle: nil)
//            let viewNavi = storyBoard.instantiateInitialViewController() as UINavigationController
//            let rootViewConrooler = UIApplication.sharedApplication().keyWindow?.rootViewController
//            rootViewConrooler?.showViewController(viewNavi, sender: nil)
//        })
        
    }
    
    @IBAction func showHome(sender: AnyObject) {
        
        self.tabBarController?.selectedIndex = 0
        
        self.navigationController?.popToRootViewControllerAnimated(false)
        
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
