//
//  AICouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class AICouponViewController: AIBaseViewController {
    
    //MARK: -> IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var couponTableView: UITableView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationButton: UIButton!

    
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AICouponTableViewCell
    //MARK: -> IBOutlets actions
    var viewModel: AICouponsViewModel?
    
    @IBAction func moreCouponAction(sender: UIButton) {
        let moreCouponViewController = UIStoryboard(name: "AICouponsStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("AIMoreCouponViewController") as! AIMoreCouponViewController
        self.navigationController?.pushViewController(moreCouponViewController, animated: true)
    }
    
    @IBAction func locationAction(sender: UIButton) {
        let nearCouponViewController = UIStoryboard(name: "AICouponsStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("AINearCouponViewController") as! AINearCouponViewController
        self.navigationController?.pushViewController(nearCouponViewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        //为导航栏留出位置
        edgesForExtendedLayout = .None
        couponTableView.headerBeginRefreshing()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let requestHandler = AICouponRequestHandler.sharedInstance
        requestHandler.queryMyCoupons("0", locationModel: nil, success: { (busiModel) in
            self.viewModel = busiModel
            self.couponTableView.headerEndRefreshing()
            }) { (errType, errDes) in
                AIAlertView().showError("数据刷新失败", subTitle: errDes)
        }
    }

}

extension AICouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        couponTableView.delegate = self
        couponTableView.dataSource = self
        couponTableView.separatorStyle = .None
        couponTableView.allowsSelection = false
        couponTableView.rowHeight = 78
        couponTableView.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        weak var weakSelf = self
        couponTableView.addHeaderWithCallback {
            weakSelf?.loadData()
        }
        couponTableView.addHeaderRefreshEndCallback {
            weakSelf?.couponTableView.reloadData()
        }

    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.couponsModel!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AICouponTableViewCell
        if let viewModel = viewModel {
            cell.model = viewModel.couponsModel![indexPath.row]
        }
        
        return cell

    }
}
