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
    var viewModel: AIWorkOpportunityDetailViewModel?
    //MARK: -> Constants

    
    @IBAction func commitAction(sender: UIButton) {
        switchTabsTo(2)
    }
    
    @IBAction func stepOneAction(sender: AnyObject) {
        switchTabsTo(1)
    }
    
    @IBAction func stepTwoAction(sender: AnyObject) {
        switchTabsTo(2)
    }
    
    
    static let title1IconOff = UIImage(named: "work_1_off")
    static let title1IconOn = UIImage(named: "work_1_on")
    static let title2IconOff = UIImage(named: "work_2_off")
    static let title2IconOn = UIImage(named: "work_2_on")

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
        commitButton.setTitle("Next", forState: UIControlState.Normal)
        makeNavigationItem()
        buildPopupView()
        qualificationView.delegate = self
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
            commitButton.setTitle("Next", forState: UIControlState.Normal)
        } else {
            curStep = 2
            title1Icon.image = AIWorkInfoViewController.title1IconOff
            title2Icon.image = AIWorkInfoViewController.title2IconOn
            jobDescTitleLabel.selected = false
            Qualification.selected = true
            jobDesContainerView.hidden = true
            qualificationView.hidden = false
            commitButton.setTitle("Subscribe", forState: UIControlState.Normal)
        }
    }
    
    func makeNavigationItem() {
        
        setupNavigationBarLikeLogin(title: "Hospital Chaperone", needCloseButton: false)
    }
}

extension AIWorkInfoViewController: AIWorkQualificationViewDelegate {
    func uploadAction(carousel: iCarousel, qualificationBusiModel: AIWorkQualificationBusiModel) {
        //把弹出view放到最上面
        view.bringSubviewToFront(uploadPopView)
        SpringAnimation.spring(0.5) {
            self.uploadPopView.alpha = 1
            self.uploadPopView.containerBottomConstraint.constant = 300
            self.uploadPopView.layoutIfNeeded()
        }
    }
    
}
