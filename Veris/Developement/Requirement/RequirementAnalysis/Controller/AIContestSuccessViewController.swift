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


    //
    var serviceInstanceID: Int = 0
    var serviceID: Int = 0
    var customerID: Int = 0
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
        seperateViewNeeds.loadData("AIContestSuccessViewController.UserNeeds".localized)
        seperateViewUser.loadData("AIContestSuccessViewController.Congratulations".localized)
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
        //取消navigationbar隐藏
        self.navigationController?.navigationBarHidden = false
        let NAVIGATION_TITLE = AITools.myriadSemiCondensedWithSize(80 / 3)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        let titleLabel = UILabel(frame: frame)
        titleLabel.font = NAVIGATION_TITLE
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "AIContestSuccessViewController.NavigationBarTitle".localized
        self.navigationItem.titleView = titleLabel
        let backImage = UIImage(named: "se_back")
        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backAction(_:)))
        leftButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        
        
        
        let rightImage = UIImage(named: "dismiss_close")
        let rightButtonItem = UIBarButtonItem(image: rightImage, style: UIBarButtonItemStyle.Plain, target: self, action:#selector(AIContestSuccessViewController.dismissVC))
        rightButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
//        dismiss_close
    }
    
    func backAction(button: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func dismissVC() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    func loadData() {

        let manager = BDKExcuteManager()
        self.showLoading()

        let body = ["service_instance_id": serviceInstanceID, "service_id" : serviceID, "customer_user_id" : customerID]
        manager.queryQaingDanResultInfo(body, success: { (resultModel) in
            if let model: AIQiangDanResultModel = resultModel {
                self.fillRealData(model)
                self.orderInfoViewLoadData(model)

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
    func orderInfoViewLoadData(model: AIQiangDanResultModel) {
//        let orderInfosModel = [AIIconLabelViewModel(labelText: "November 3, 2015", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png"), AIIconLabelViewModel(labelText: "Haidian District Garden Road, Beijing, 49", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png"), AIIconLabelViewModel(labelText: "Accompany pregnant woman to produce a check, queue,take a number, buy foodGeneration of pregnant women", iconUrl: "http://171.221.254.231:3000/upload/shoppingcart/CTQJUtkd0VWNI.png")]
        if let orderParamsJSONModel = model.service_process.service_param_list as? [AIQiangDanServiceParamModel] {
            var orderInfosModel = Array<AIIconLabelViewModel>()
            for orderParamJSONModel: AIQiangDanServiceParamModel in orderParamsJSONModel {
                let labelText = orderParamJSONModel.param_value ?? ""
                let iconUrl = orderParamJSONModel.param_icon ?? ""
                let orderInfoModel = AIIconLabelViewModel(labelText: labelText, iconUrl: iconUrl)
                orderInfosModel.append(orderInfoModel)
            }
            orderInfoView.loadData(orderInfosModel)
        }
        
    }
    

    // MARK: - IBActions
    @IBAction func startWorkAction(sender: AnyObject) {
        
        self.showLoading()
        let manager = BDKExcuteManager()
        manager.startServiceProcess(serviceInstanceID, success: { (responseData) in
            if let _ = self.qiangDanResultModel {
                self.showLoading()
                let taskDetailVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.TaskDetailViewController) as! TaskDetailViewController
                taskDetailVC.serviceInstanceID = self.serviceInstanceID
                taskDetailVC.customerUserID = self.customerID
                taskDetailVC.serviceID = self.serviceID
                self.navigationController?.pushViewController(taskDetailVC, animated: true)
            }
            }) { (errType, errDes) in
                self.dismissLoading()
                AIAlertView().showError("启动工作失败", subTitle: errDes)
        }

        

    }
}
