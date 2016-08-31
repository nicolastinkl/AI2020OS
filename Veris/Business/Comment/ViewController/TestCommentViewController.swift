//
//  TestCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/8/19.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TestCommentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testAction(sender: AnyObject) {
        let vc = TaskResultCommitViewController.initFromStoryboard()
        
        let nav = UINavigationController(rootViewController: vc)
        presentViewController(nav, animated: true, completion: nil)
    }
    

}
