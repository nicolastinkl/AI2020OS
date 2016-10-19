//
//  AIWorkInfoViewController.swift
//  AIVeris
//
//  Created by 刘先 on 8/1/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView
import iCarousel
import Spring
import SnapKit

class AIWorkInfoViewController: UIViewController {
    
    
    @IBOutlet weak var qualificationView: AIWorkQualificationView!
    @IBOutlet weak var title2Icon: UIImageView!
    @IBOutlet weak var title1Icon: UIImageView!
    @IBOutlet weak var jobDesContainerView: AIWorkDetailView!
    @IBOutlet weak var Qualification: UIButton!
    @IBOutlet weak var jobDescTitleLabel: UIButton!
    @IBOutlet weak var serviceIconView: UIImageView!
    @IBOutlet weak var commitButton: UIButton!
    
    //extra view
    var uploadPopView: AIWorkUploadPopView!
    
    var qualificationShowMode = 1
    var curStep: Int = 1
    
    //MARK: -> variable passed from previous page
    var in_workId: String? {
        didSet {
            if let _ = in_workId {
                loadData()
            }
        }
    }
    var in_workName: String = "陪护"
    
    var viewModel: AIWorkOpportunityDetailViewModel?
    //保存全局的条款是否checkbox是否勾选
    var isAcceptTerm: Bool = false
    //工作机会是否以订阅
    var isSubscribed: Bool? {
        didSet {
            if let isSubscribed = isSubscribed {
                commitButton.hidden = isSubscribed
            }
        }
    }
    
    //MARK: -> Constants
    static let title1IconOff = UIImage(named: "work_1_off")
    static let title1IconOn = UIImage(named: "work_1_on")
    static let title2IconOff = UIImage(named: "work_2_off")
    static let title2IconOn = UIImage(named: "work_2_on")
    
    //MARK: -> IBAction
    @IBAction func commitAction(sender: UIButton) {
        if curStep == 1{
            //这里还有一个逻辑，当checkbox选中才能点下一步
            switchTabsTo(2)
        } else {
            subscribeWork()
        }
        
    }
    
    @IBAction func stepOneAction(sender: AnyObject) {
        switchTabsTo(1)
    }
    
    @IBAction func stepTwoAction(sender: AnyObject) {
        switchTabsTo(2)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        //commitButton
        commitButton.layer.cornerRadius = 180.displaySizeFrom1242DesignSize() / 2
        commitButton.layer.masksToBounds = true
        commitButton.setTitle("AIWorkInfoViewController.Next".localized, forState: UIControlState.Normal)
        commitButton.setBackgroundImage(UIColor.grayColor().imageWithColor(), forState: UIControlState.Disabled)
        commitButton.enabled = false
        makeNavigationItem()
        buildPopupView()
        qualificationView.delegate = self
        jobDesContainerView.delegate = self
        Qualification.setTitle("AIWorkInfoViewController.QualificationTitle".localized, forState: UIControlState.Normal)
        jobDescTitleLabel.setTitle("AIWorkInfoViewController.JobDescriptionTitle".localized, forState: .Normal)
    }
    
    private func buildPopupView() {
        
        uploadPopView = AIWorkUploadPopView.createInstance()
        uploadPopView.alpha = 0
        view.addSubview(uploadPopView)
        uploadPopView.snp_makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
    }
    
    func loadData() {
        let requestHandler = AIWorkManageRequestHandler.sharedInstance
        weak var weakSelf = self
        requestHandler.queryWorkOpportunity(in_workId!, success: { (busiModel1) in
            requestHandler.queryWorkQualification(self.in_workId!, success: { (busiModel2) in
                requestHandler.parseWorkBusiModelsToViewModel(workOpptunityBusiModel: busiModel1, workQualificationsBusiModel: busiModel2, success: { (viewModel) in
                    weakSelf?.viewModel = viewModel
                    weakSelf?.bindViewData()
                    
                    }, fail: { (errType, errDes) in
                        AIAlertView().showError("数据转换失败", subTitle: errDes)
                })
                }, fail: { (errType, errDes) in
                    AIAlertView().showError("数据请求失败", subTitle: errDes)
            })
            }) { (errType, errDes) in
                AIAlertView().showError("数据请求失败", subTitle: errDes)
        }
    }
    
    func bindViewData() {
        //给子view赋值
        qualificationView.viewModel = viewModel
        jobDesContainerView.workDetailModel = viewModel
        let imageUrl = viewModel!.opportunityBusiModel!.work_thumbnail!
        serviceIconView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "wm-icon2")!, options: SDWebImageOptions.RetryFailed)
        //设置是否订阅标志
        if viewModel!.opportunityBusiModel!.subscribed_flag.intValue == 1 {
            isSubscribed = true
        } else {
            isSubscribed = false
        }
    }

    func switchTabsTo(step: Int) {
        if step == 1 {
            curStep = 1
            title1Icon.image = AIWorkInfoViewController.title1IconOn
            title2Icon.image = AIWorkInfoViewController.title2IconOff
            jobDescTitleLabel.selected = true
            Qualification.selected = false
            jobDesContainerView.hidden = false
            qualificationView.hidden = true
            commitButton.setTitle("AIWorkInfoViewController.Next".localized, forState: UIControlState.Normal)
            commitButton.enabled = isAcceptTerm
        } else {
            curStep = 2
            title1Icon.image = AIWorkInfoViewController.title1IconOff
            title2Icon.image = AIWorkInfoViewController.title2IconOn
            jobDescTitleLabel.selected = false
            Qualification.selected = true
            jobDesContainerView.hidden = true
            qualificationView.hidden = false
            commitButton.setTitle("AIWorkInfoViewController.Subscribe".localized, forState: UIControlState.Normal)
        }
    }
    
    func makeNavigationItem() {
        setupNavigationBarLikeLogin(title: in_workName, needCloseButton: false)
    }
    
    func subscribeWork() {
        let requestHandler = AIWorkManageRequestHandler.sharedInstance
        requestHandler.subscribeWorkOpportunity(in_workId!, success: { (resultCode) in
            AIAlertView().showError("订阅成功", subTitle: self.viewModel!.opportunityBusiModel!.work_name)
            }) { (errType, errDes) in
                AIAlertView().showError("订阅失败", subTitle: errDes)
        }
    }
}

extension AIWorkInfoViewController: AIWorkQualificationViewDelegate, AIWorkDetailViewDelegate {
    func uploadAction(carousel: iCarousel, qualificationBusiModel: AIWorkQualificationBusiModel) {
        //把弹出view放到最上面
        view.bringSubviewToFront(uploadPopView)
        SpringAnimation.spring(0.5) {
            self.uploadPopView.alpha = 1
            self.uploadPopView.containerBottomConstraint.constant = 300
            self.uploadPopView.layoutIfNeeded()
        }
    }
    
    func acceptTerm(isAccept: Bool) {
        commitButton.enabled = isAccept
        isAcceptTerm = isAccept
    }
}



extension AIWorkInfoViewController: AIWorkUploadPopViewDelegate {

    func shouldTakePhoto() {
        let scanVC = AIScanBankCardViewController()
        let nav = UINavigationController(rootViewController: scanVC)
        showTransitionStyleCrossDissolveView(nav)

        if let model = viewModel?.qualificationsBusiModel?.work_qualifications[qualificationView.carousel.currentItemIndex] as? AIWorkQualificationBusiModel {
            scanVC.aspectID = model.aspect_type.toInt()!
        }

    }


    func shouldChoosePhoto() {
        let vc = AIAssetsPickerController.initFromNib()
        vc.delegate = self
        vc.maximumNumberOfSelection = 1
        let nav = UINavigationController(rootViewController: vc)
        showTransitionStyleCrossDissolveView(nav)
    }
}

extension AIWorkInfoViewController: AIAssetsPickerControllerDelegate {
    /**
     完成选择

     1. 缩略图： UIImage(CGImage: assetSuper.thumbnail().takeUnretainedValue())
     2. 完整图： UIImage(CGImage: assetSuper.fullResolutionImage().takeUnretainedValue())
     */
    func assetsPickerController(picker: AIAssetsPickerController, didFinishPickingAssets assets: NSArray) {


        for asset in assets {
            if asset is ALAsset {
                //let image = AIALAssetsImageOperator.thumbnailImageForAsset(asset as! ALAsset, maxPixelSize: 500)

            }
        }


    }

    /**
     取消选择
     */
    func assetsPickerControllerDidCancel() {

    }

    /**
     选中某张照片
     */
    func assetsPickerController(picker: AIAssetsPickerController, didSelectItemAtIndexPath indexPath: NSIndexPath) {

    }

    /**
     取消选中某张照片
     */
    func assetsPickerController(picker: AIAssetsPickerController, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

