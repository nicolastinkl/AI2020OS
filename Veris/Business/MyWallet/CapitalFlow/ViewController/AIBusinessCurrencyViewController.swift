//
//  AIBusinessCurrencyViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AIBusinessCurrencyViewController: AIBaseViewController {

    // MARK: -> Interface Builder variables
    
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var ruleDescButton: UIButton!
    @IBOutlet weak var viewTitleLabel: UILabel!
    
    var popupRuleView: AIPopupSContainerView!
    var bcDetailView: AIBCDetailView!
    
    // MARK: -> Interface Builder actions
    
    
    @IBAction func showRuleAction(sender: UIButton) {
        view.bringSubviewToFront(popupRuleView)
        SpringAnimation.spring(0.5) {
            self.popupRuleView.alpha = 1
            self.popupRuleView.containerBottomConstraint.constant = 300
            self.popupRuleView.layoutIfNeeded()
        }
    }

    // MARK: -> Class override UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -> private methods
    func setupViews() {
        setupTableView()
        setupPopupView()
        //为导航栏留出位置
        edgesForExtendedLayout = .None
    }
    
    private func setupPopupView() {
        popupRuleView = AIPopupSContainerView.createInstance()
        popupRuleView.alpha = 0
        view.addSubview(popupRuleView)
        popupRuleView.snp_makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        
        bcDetailView = AIBCDetailView.createInstance()
    }

    // MARK: -> delegates
    
    // MARK: -> util methods
}

extension AIBusinessCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
