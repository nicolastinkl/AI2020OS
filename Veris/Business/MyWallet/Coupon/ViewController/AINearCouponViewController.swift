//
//  AINearCouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AINearCouponViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIImageView!
    
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var locationStatusImage: UIImageView!
    @IBOutlet weak var locationContainerView: UIView!
    @IBOutlet weak var manulLocateButton: UIButton!
    @IBOutlet weak var couponTableView: UITableView!
    @IBOutlet weak var dotLine: UIImageView!
    @IBOutlet weak var locationStatusIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!

    
    @IBAction func retryAction(sender: AnyObject) {
    }
    
    @IBAction func manulLocateAction(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
