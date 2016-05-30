//
//  AISearchNaviViewController.swift
//  AI2020OS
//
//  Created by tinkl on 13/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AISearchNaviViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func closeThisView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //        self.navigationController?.dismissViewControllerAnimated(true, completion:nil)
        
    }
    
    
    @IBAction func showAudioSearchView(sender: AnyObject) {
        let viewControl:AIISRViewController = AIISRViewController()
        self.presentViewController(viewControl, animated: false) { () -> Void in
            
        }
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}