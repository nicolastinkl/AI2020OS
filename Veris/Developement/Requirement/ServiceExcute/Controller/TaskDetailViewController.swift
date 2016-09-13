//
//  TaskDetailViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/5/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    @IBOutlet weak var nodeTitleLabel: UILabel!
    @IBOutlet weak var param1IconLabel: IconLabel!
    @IBOutlet weak var param2IconLabel: IconLabel!
    @IBOutlet weak var QRCodeImage: ServiceQRCodeView!
    @IBOutlet weak var nodeDesc: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBOutlet weak var authorizationBg: UIImageView!
    @IBOutlet weak var promptAuthorization: UILabel!
    @IBOutlet weak var waitingIcon: UIImageView!
    @IBOutlet weak var waitingMask: UIVisualEffectView!
    @IBOutlet weak var customerView: AICustomerBannerView!
    
    private let paraIconHeight: CGFloat = 20
    
    var serviceInstanceID: Int = 0
    var customerUserID: Int = 0
    var serviceID: Int = 0
    
    private var procedure: Procedure?
    private var customer: AICustomerModel?
    private var authorityState: AuthorityState?
    


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.opaque = false
        self.navigationController?.navigationBarHidden = false
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomButton.layer.cornerRadius = bottomButton.height / 2
        nodeDesc.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        nodeTitleLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(80))
        bottomButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(72))
        promptAuthorization.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(80))
  
        buildNavigationTitleLabel()
        
        loadData()
    }
    
    private func setupCustomerView() {
        guard let userModel = customer else {
            return
        }
        
        customerView.userNameLabel.text = userModel.user_name
        customerView.userIconImageView.sd_setImageWithURL(NSURL(string: userModel.user_portrait_icon), placeholderImage: UIImage(named: "Avatorbibo"))
        customerView.userPhoneString = userModel.user_phone
        customerView.customerDescLabel.text = ""
    }
    
    class func initFromStoryboard() -> TaskDetailViewController {
        let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.TaskDetailViewController) as! TaskDetailViewController
        return vc
    }

    class func setBottomButtonEnabel(button: UIButton, enable: Bool) {
        let color = enable ? UIColor(hex: "0F86E8") : UIColor(hexString: "#393879", alpha: 0.6)
        let textColor = enable ? UIColor.whiteColor() : UIColor(hexString: "#1a1a58")
        button.backgroundColor = color
        button.setTitleColor(textColor, forState: .Normal)
        button.enabled = enable
    }
    
    func buildNavigationTitleLabel() {
        extendedLayoutIncludesOpaqueBars = true
        
        let NAVIGATION_TITLE = AITools.myriadSemiCondensedWithSize(80 / 3)
        let frame = CGRect(x: 0, y: 0, width: 100, height: 44)
        let titleLabel = UILabel(frame: frame)
        titleLabel.font = NAVIGATION_TITLE
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "TaskResultCommitViewController.title".localized
        self.navigationItem.titleView = titleLabel
        let backImage = UIImage(named: "se_back")
        
        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backAction(_:)))
        leftButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.leftBarButtonItem = leftButtonItem
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }

    func backAction(button: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    private func loadData() {
        showLoading()
        
        let manager = BDKExcuteManager()
        
        manager.queryProcedureInstInfo(serviceId: serviceID, serviceInstId: serviceInstanceID, userId: customerUserID, success: { (responseData) in
            
            self.dismissLoading()
            self.procedure = responseData.procedure
            self.customer = responseData.customer
            
            self.initAuthorityState()
            self.setupUI()
            
            
            }) { (errType, errDes) in
                self.dismissLoading()
                NBMaterialToast.showWithText(self.view, text: "GetDataFailed".localized, duration: NBLunchDuration.SHORT)
        }
    }
    
    private func setupUI() {
        setupCustomerView()
        
        guard let p = procedure else {
            return
        }
        
        nodeTitleLabel.text = p.node_info.node_title
        nodeDesc.text = p.node_info.node_desc
        
        if let params = p.param_list {
            
            if params.count != 0 {
                for index in 0 ..< params.count {
                    
                    if index > 1 {
                        break
                    }
                    
                    guard let node = params[index] as? NodeParam else {
                        continue
                    }
                    
                    var paramLabel: IconLabel?
                    
                    if index == 0 {
                        paramLabel = param1IconLabel
                    } else if index == 1 {
                        paramLabel = param2IconLabel
                    }
                    
                    paramLabel?.hidden = false
                    paramLabel?.labelContent = node.value
       
                    if let icon = node.icon {
                        let url = NSURL(string: icon)
                        paramLabel?.icon.sd_setImageWithURL(url, completed: { (image, error, type, url) in
                            if let im = image {
                                let scaleRate = im.size.height / self.paraIconHeight
                                let newSize = CGSize(width: im.size.width / scaleRate, height: im.size.height / scaleRate)
                                let newImage = im.resizedImageToFitInSize(newSize, scaleIfSmaller: true)
                                paramLabel?.icon.image = newImage
                            }
                        })
                    }
                    
                }
            }
        }
        
        authorityState?.setupAuthorityUI()
    }
    
    private func initAuthorityState() {
        guard let p = procedure else {
            return
        }
        
        let permissionType = p.permission_type.integerValue
        
        if permissionType == ProcedureType.jurisdiction.rawValue {
            if let jurisdictionStatus = JurisdictionStatus(rawValue: p.permission_value.integerValue) {
                switch jurisdictionStatus {
                case .notAuthorized:
                    authorityState = NeedAuthority(vc: self)
                case .alreadyAuthorized:
                    authorityState = AlreadyAuthorized(vc: self)
                case .noNeed:
                    authorityState = NoNeedAuthority(vc: self)
                }
            }
        } else if permissionType == ProcedureType.confirm.rawValue {
            authorityState = AlreadyAuthorized(vc: self)
        } else {
            authorityState = NoNeedAuthority(vc: self)
        }
    }
    
    private func afterAuthorizationSetupUI() {
        if let p = procedure {
            switch p.status {
            case ProcedureStatus.noStart.rawValue:
                TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: true)
                bottomButton.setTitle("TaskDetailViewController.start".localized, forState: .Normal)
            case ProcedureStatus.excuting.rawValue:
                TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: true)
                bottomButton.setTitle("TaskDetailViewController.complete".localized, forState: .Normal)
            case ProcedureStatus.complete.rawValue:
                bottomButton.hidden = true
            default:
                break
                
            }
        }
        
    }
    
    private func showAuthorization() {
        promptAuthorization.hidden = false
        authorizationBg.hidden = false
        waitingIcon.hidden = false
        waitingMask.hidden = false
        
        TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: false)
        bottomButton.setTitle("TaskDetailViewController.requestAuthoriztion".localized, forState: .Normal)
        bottomButton.setTitle("TaskDetailViewController.requestAuthoriztion".localized, forState: .Disabled)
    }
    
    private func hideAuthorization() {
        promptAuthorization.hidden = true
        authorizationBg.hidden = true
        waitingIcon.hidden = true
        waitingMask.hidden = true
        
        TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: true)
    }
    
    @IBAction func bottomButtonAction(sender: AnyObject) {
        authorityState?.bottomBtnClicked()
    }
    
    func bottomBtnActionOfAlreadyAuthorized() {
        guard let p = procedure else {
            return
        }
        
        switch p.status {
        case ProcedureStatus.noStart.rawValue:
            updateServiceStatus()
        case ProcedureStatus.excuting.rawValue:
            openTaskCommitViewController()
        default:
            break
            
        }
    }
    
    private func submitAuthorization() {
        
        guard let c = customer else {
            return
        }
        
        let manager = BDKExcuteManager()
        
        showLoading()
        
        guard let procedureInstId = procedure?.procedure_inst_id else {
            AILog("procedureInstId 不存在！")
            return
        }
        manager.submitRequestAuthorization(procedureInstId.integerValue, customerId: c.user_id, success: { (responseData) in
            
            self.dismissLoading()
            switch responseData {
            case .success:
                NBMaterialToast.showWithText(self.view, text: "SubmitSuccess".localized, duration: NBLunchDuration.SHORT)
            default:
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
            }
            
            }) { (errType, errDes) in
                
                self.dismissLoading()
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
        }
    }
    
    private func updateServiceStatus() {
        let manager = BDKExcuteManager()
        
        showLoading()
        
        manager.updateServiceNodeStatus(procedure!.procedure_inst_id.integerValue, status: ProcedureStatus.excuting, success: { (responseData) in
            
            self.dismissLoading()
 
            switch responseData {
                
            case .success:
                NBMaterialToast.showWithText(self.view, text: "SubmitSuccess".localized, duration: NBLunchDuration.SHORT)
                
                self.procedure?.status = ProcedureStatus.excuting.rawValue
                self.bottomButton.setTitle("TaskDetailViewController.complete".localized, forState: .Normal)
                
            default:
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
            }
            
            }) { (errType, errDes) in
                
                self.dismissLoading()
                
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
                
        }
    }
    
    private func openTaskCommitViewController() {
        let taskResultCommitlVC = TaskResultCommitViewController.initFromStoryboard(AIApplication.MainStoryboard.MainStoryboardIdentifiers.TaskExecuteStoryboard, storyboardID: nil)
        taskResultCommitlVC.procedureId = procedure!.procedure_inst_id.integerValue
        taskResultCommitlVC.serviceId = serviceInstanceID
        taskResultCommitlVC.delegate = self
        
        let nav = UINavigationController(rootViewController: taskResultCommitlVC)
        presentViewController(nav, animated: true, completion: nil)
    }
    
    class AuthorityState {
        
        let vc: TaskDetailViewController
        
        init(vc: TaskDetailViewController) {
            self.vc = vc
        }
        
        func setupAuthorityUI() {
            
        }
        
        func bottomBtnClicked() {
            
        }
    }
    
    class NeedAuthority: AuthorityState {

        override func setupAuthorityUI() {
            vc.showAuthorization()
            TaskDetailViewController.setBottomButtonEnabel(vc.bottomButton, enable: true)
        }
        
        override func bottomBtnClicked() {
            vc.submitAuthorization()
        }
    }
    
    class AlreadyAuthorized: AuthorityState {
        
        override func setupAuthorityUI() {
            vc.hideAuthorization()
            vc.afterAuthorizationSetupUI()
        }
        
        override func bottomBtnClicked() {
            vc.bottomBtnActionOfAlreadyAuthorized()
        }
    }
    
    class WaitingAuthorized: AuthorityState {
        
        override func setupAuthorityUI() {
            vc.showAuthorization()
            TaskDetailViewController.setBottomButtonEnabel(vc.bottomButton, enable: false)
        }
    }
    
    class NoNeedAuthority: AlreadyAuthorized {
        
    }
}

extension TaskDetailViewController: TeskResultCommitDelegate {
    func hasNextNode(hasNextNode: Bool) {
        if hasNextNode {
            loadData()
        } else {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}
