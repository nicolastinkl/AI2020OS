//
//  AIMoreCouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AIMoreCouponViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabContainerView: UIView!
    
    var filterBar: AIFilterBar!
    var commentsNumbers = [
        "0",
        "0",
        "0"
    ]
    var popupDetailView: AIPopupSContainerView!
    var couponDetailView: AICouponDetailView!
    
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AIIconCouponTableViewCell

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFilterBar()
        buildBgView()
        setupPopupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupFilterBar() {
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
    
    private func buildBgView() {
        let bgView = UIImageView()
        bgView.image = UIImage(named: "effectBgView")
        view.insertSubview(bgView, atIndex: 0)
        bgView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    private func setupPopupView() {
        popupDetailView = AIPopupSContainerView.createInstance()
        popupDetailView.alpha = 0
        view.addSubview(popupDetailView)
        popupDetailView.snp_makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        
        couponDetailView = AICouponDetailView.createInstance()
        popupDetailView.buildContent(couponDetailView)
    }

}
//MARK: -> tableview delegates
extension AIMoreCouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        tableView.rowHeight = 93
        tableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AIIconCouponTableViewCell
        cell.delegate = self
        return cell
        
    }
}

//MARK: -> delegates
extension AIMoreCouponViewController: AIFilterBarDelegate, AIIconCouponTableViewCellDelegate {
    
    func filterBar(filterBar: AIFilterBar, didSelectIndex: Int) {
        //fetchComments()
        tableView.reloadData()
    }
    
    func useAction() {
        view.bringSubviewToFront(popupDetailView)
        popupDetailView.containerHeightConstraint.constant = 400
        popupDetailView.layoutIfNeeded()
        SpringAnimation.spring(0.5) {
            self.popupDetailView.alpha = 1
            self.popupDetailView.containerBottomConstraint.constant = 200
            self.popupDetailView.layoutIfNeeded()
        }
    }
}
