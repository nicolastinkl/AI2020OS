//
//  OrderListViewController.swift
//  AI2020OS
//
//  Created by 刘先 on 15/5/26.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Cartography


class AIOrderListViewController:UIViewController{

    // MARK: - IBOutlets
    @IBOutlet weak var customerOrderView: UIView!
    @IBOutlet weak var providerOrderView: UIView!
    
    // MARK: - life cycle
    override func viewWillAppear(animated: Bool) {
//        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerOrderView.hidden = false
    }

}