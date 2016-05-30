//
//  AIAudioViewController.swift
//  AI2020OS
//
//  Created by tinkl on 9/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIAudioViewController:UIViewController {
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func closeThisView(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
//        self.navigationController?.dismissViewControllerAnimated(true, completion:nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}