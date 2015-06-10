//
//  AIConnectMeunViewController.swift
//  AI2020OS
//
//  Created by tinkl on 8/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIConnectMeunViewController: DLHamburguerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        self.contentViewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIMainStoryboard, bundle: nil).instantiateInitialViewController() as UIViewController
        
     //   self.menuViewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AITagFilterStoryboard, bundle: nil).instantiateInitialViewController() as AITagFilterViewController
    }

}