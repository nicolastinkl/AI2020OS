//
//  AICustomerOrderDetailViewController.swift
//  AI2020OS
//
//  Created by 刘先 on 15/8/18.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICustomerOrderDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var backItem = UIBarButtonItem(image: UIImage(named: "ico_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "leftAction")
        self.navigationItem.leftBarButtonItem = backItem
        
        self.title = "订单详情"
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
