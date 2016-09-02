//
//  AIContestSuccessViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

@objc class AIContestSuccessViewController: UIViewController {

    
    @IBOutlet weak var seperateViewNeeds: AIDottedLineLabelView!
    @IBOutlet weak var orderInfoView: AIIconLabelVerticalContainerView!
    @IBOutlet weak var seperateViewUser: AIDottedLineLabelView!
    @IBOutlet weak var customerBannerView: AICustomerBannerView!


    var serviceInstanceID: Int = 0
    var qiangDanResultModel: AIQiangDanResultModel?
    //MARK: Life Cycle


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.opaque = false
        self.navigationController?.navigationBarHidden = false
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        extendedLayoutIncludesOpaqueBars = true
        // Do any additional setup after loading the view.
        buildNavigationTitleLabel()
        seperateViewNeeds.loadData("用户需要")
        seperateViewUser.loadData("抢单成功")
        customerBannerView.delegate = self
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Actions

    


    //MARK: Other Functions


    func buildNavigationTitleLabel() {

        let NAVIGATION_TITLE = AITools.myriadSemiCondensedWithSize(80 / 3)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        let titleLabel = UILabel(frame: frame)
        titleLabel.font = NAVIGATION_TITLE
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "服务细节"
        self.navigationItem.titleView = titleLabel
        let backImage = UIImage(named: "se_back")
        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AIContestSuccessViewController.backAction(_:)))
        leftButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    func backAction(button: UIBarButtonItem) {

        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    

    func loadData() {

        let manager = BDKExcuteManager()
        self.showLoading()
        manager.queryQaingDanResultInfo(serviceInstanceID, success: { (resultModel) in
            if let model: AIQiangDanResultModel = resultModel {
                self.fillRealData(model)
                //self.orderInfoViewLoadFakeData(model)

                self.dismissLoading()
            }
            }) { (error, errorDesc) in
                self.dismissLoading()
                AIAlertView().showError(errorDesc, subTitle: "")
                self.qiangDanResultModel = nil
        }
    }

    func fillRealData(model: AIQiangDanResultModel) {

        self.qiangDanResultModel = model
        self.orderInfoView.descLabel.text = model.service_process.service_desc
        customerBannerView.userNameLabel.text = model.customer.user_name
        customerBannerView.userIconImageView.sd_setImageWithURL(NSURL(string: model.customer.user_portrait_icon), placeholderImage: UIImage(named: "se_customer_icon"))
        customerBannerView.userPhoneString = model.customer.user_phone
        customerBannerView.customerDescLabel.text = ""//"怀孕9周"
    }


    /* 暂时废弃,等待后台配置以后再打开此功能

     */
    func orderInfoViewLoadFakeData(model: AIQiangDanResultModel) {
        let orderInfosModel = [AIIconLabelViewModel(labelText: "November 3, 2015", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png"), AIIconLabelViewModel(labelText: "Haidian District Garden Road, Beijing, 49", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png"), AIIconLabelViewModel(labelText: "Accompany pregnant woman to produce a check, queue,take a number, buy foodGeneration of pregnant women", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png")]
        orderInfoView.loadData(orderInfosModel)
    }
    

    // MARK: - IBActions
    @IBAction func startWorkAction(sender: AnyObject) {

        if let _ = qiangDanResultModel {
            let taskDetailVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.TaskDetailViewController) as! TaskDetailViewController
            taskDetailVC.serviceId = serviceInstanceID
                self.navigationController?.pushViewController(taskDetailVC, animated: true)
        }

    }
}
