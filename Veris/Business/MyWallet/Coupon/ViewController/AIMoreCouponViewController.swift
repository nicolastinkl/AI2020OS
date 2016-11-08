//
//  AIMoreCouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring
import AIAlertView

class AIMoreCouponViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabContainerView: UIView!
    
    
    @IBAction func locateAction(sender: AnyObject) {
        let nearCouponViewController = UIStoryboard(name: "AICouponsStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("AINearCouponViewController") as! AINearCouponViewController
        self.navigationController?.pushViewController(nearCouponViewController, animated: true)
    }
    
    var filterBar: AIFilterBar!
    var popupDetailView: AIPopupSContainerView!
    var couponDetailView: AICouponDetailView!
    
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AIIconCouponTableViewCell
    
    var viewModel: AICouponsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFilterBar()
        buildBgView()
        setupPopupView()
        tableView.headerBeginRefreshing()
        loadData()
        setupNavigationController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationController() {
        if let navController = self.navigationController {
            setupNavigationBarLikeWorkInfo(title: "我的优惠券", needCloseButton: false)
            navController.navigationBarHidden = false
            edgesForExtendedLayout = .None
        }
    }
    
    private func setupFilterBar() {
        let titles = [
            "可用",
            "已使用",
            "已过期"
        ]
        
        filterBar = AIFilterBar(titles: titles, subtitles: nil)
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
    
    func loadData() {
        let requestHandler = AICouponRequestHandler.sharedInstance
        let filterIndex = filterBar.selectedIndex + 1
        requestHandler.queryMyCoupons(filterIndex.toString(), city: nil , locationModel: nil, success: { (busiModel) in
            self.viewModel = busiModel
            self.tableView.headerEndRefreshing()
        }) { (errType, errDes) in
            AIAlertView().showError("数据刷新失败", subTitle: errDes)
        }
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
        weak var weakSelf = self
        tableView.addHeaderWithCallback {
            weakSelf?.loadData()
        }
        tableView.addHeaderRefreshEndCallback {
            weakSelf?.tableView.reloadData()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.couponsModel!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AIIconCouponTableViewCell
        cell.delegate = self
        if let viewModel = viewModel {
            cell.model = viewModel.couponsModel![indexPath.row]
        }
        return cell
        
    }
}

//MARK: -> delegates
extension AIMoreCouponViewController: AIFilterBarDelegate, AIIconCouponTableViewCellDelegate {
    
    func filterBar(filterBar: AIFilterBar, didSelectIndex: Int) {
        tableView.headerBeginRefreshing()
        loadData()
    }
    
    func useAction(model model: AIVoucherBusiModel) {
        //更新数据
        couponDetailView.model = model
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
