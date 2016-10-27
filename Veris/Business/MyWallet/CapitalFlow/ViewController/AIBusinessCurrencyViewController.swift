//
//  AIBusinessCurrencyViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIBusinessCurrencyViewController: UIViewController {

    // MARK: -> Interface Builder variables
    
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var ruleDescButton: UIButton!
    @IBOutlet weak var viewTitleLabel: UILabel!
    
    // MARK: -> Interface Builder actions
    
    @IBAction func showRuleAction(sender: UIButton) {
        
    }
    
    // MARK: -> Class override UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: -> delegates
    
    // MARK: -> util methods
}
