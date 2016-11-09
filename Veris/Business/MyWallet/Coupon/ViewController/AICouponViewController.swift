//
//  AICouponViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class AICouponViewController: UIViewController {
    
    //MARK: -> IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var couponTableView: UITableView!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationButton: UIButton!
    
    //MARK: -> Constants
    let cellIdentifier = AIApplication.MainStoryboard.CellIdentifiers.AICouponTableViewCell
    let BUTTON_FONT = AITools.myriadLightSemiCondensedWithSize(48.displaySizeFrom1242DesignSize())
    let BUTTON_TEXT_COLOR = UIColor(hexString: "#ffffff", alpha: 0.5)
    
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
        setupViews()
        //为导航栏留出位置
        //edgesForExtendedLayout = .None
        couponTableView.headerBeginRefreshing()
        loadData()
        setupNavigationController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        moreButton.titleLabel?.font = BUTTON_FONT
        moreButton.setTitleColor(BUTTON_TEXT_COLOR, forState: UIControlState.Normal)
        locationButton.titleLabel?.font = BUTTON_FONT
        locationButton.setTitleColor(BUTTON_TEXT_COLOR, forState: .Normal)
    }
    
    func setupNavigationController() {
        if let navController = self.navigationController {
            //setupNavigationBarLikeWorkInfo(title: "", needCloseButton: false)
            navController.navigationBarHidden = true
        }
    }
    
    func loadData() {
        let requestHandler = AICouponRequestHandler.sharedInstance
        requestHandler.queryMyCoupons("0", city: nil, locationModel: nil, success: { (busiModel) in
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
