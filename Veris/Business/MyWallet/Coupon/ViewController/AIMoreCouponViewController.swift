//
//  AIMoreCouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIMoreCouponViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabContainerView: UIView!
    
    var filterBar: AIFilterBar!
    var commentsNumbers = [
        "0",
        "0",
        "0"
    ]
    
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AIIconCouponTableViewCell

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupFilterBar() {
        let titles = [
            "可用",
            "已使用",
            "已过期"
        ]
        
        filterBar = AIFilterBar(titles: titles, subtitles: commentsNumbers)
        filterBar.selectedIndex = 0
        filterBar.delegate = self
        view.addSubview(filterBar)
        filterBar.snp_makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(AITools.displaySizeFrom1242DesignSize(143))
        }
    }

}

extension AIMoreCouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cell
        
    }
}

extension AIMoreCouponViewController: AIFilterBarDelegate {
    func filterBar(filterBar: AIFilterBar, didSelectIndex: Int) {
        //fetchComments()
    }
}
