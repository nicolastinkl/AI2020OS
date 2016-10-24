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
    @IBOutlet weak var QRCodeImage: ServiceQRCodeView!
    @IBOutlet weak var nodeDesc: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var paramTable: UITableView!
    
    @IBOutlet weak var nodeImage: UIImageView!
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
    private var paramNodes: [NodeParam]?


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.opaque = false
        self.navigationController?.navigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nodeDesc.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(48))
        nodeTitleLabel.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(80))
        bottomButton.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(72))
        promptAuthorization.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1080DesignSize(80))
  
        buildNavigationTitleLabel()
        
        paramTable.registerNib(UINib(nibName: "NodeParamTableViewCell", bundle: nil), forCellReuseIdentifier: "ParamCell")
        paramTable.rowHeight = UITableViewAutomaticDimension
        paramTable.estimatedRowHeight = 25
        
        paramTable.hidden = false

        loadData()
    }
    
    override func viewDidLayoutSubviews() {
        bottomButton.roundCorner(bottomButton.height / 2)
    }
    
    private func setupCustomerView() {
        guard let userModel = customer else {
            return
        }

        customerView.delegate = self
        customerView.userNameLabel.text = userModel.user_name
        customerView.userIconImageView.sd_setImageWithURL(NSURL(string: userModel.user_portrait_icon), placeholderImage: UIImage(named: "Avatorbibo"))
        customerView.userPhoneString = userModel.user_phone ?? nil
        customerView.customerDescLabel.text = ""
    }
    
    private func clearUI() {
        paramNodes = nil
        
        nodeImage.hidden = true
        nodeImage.image = nil
        
        nodeDesc.text = nil
        nodeTitleLabel.text = nil
        
        paramTable.reloadData()
        
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
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]
        
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor(hexString: "#0f0c2c"), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "TaskResultCommitViewController.title".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
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
        
        if let imageUrl = p.node_info.node_pic {
            if !imageUrl.isEmpty {
                nodeImage.hidden = false
                nodeImage.asyncLoadImage(imageUrl)
            }
        }
        
        if p.param_list != nil {
            
            if let paramNodes = p.param_list as? [NodeParam] {
                self.paramNodes = paramNodes
                paramTable.reloadData()
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
                    //如果还未授权,status=3 说明已经发送授权申请
                    if p.status == 3 {
                        authorityState = WaitingAuthorized(vc: self)
                    } else {
                        authorityState = NeedAuthority(vc: self)
                    }
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
            case ProcedureStatus.noStart.rawValue, ProcedureStatus.needAuthorize.rawValue:
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
        
        paramTable.hidden = true
        nodeTitleLabel.hidden = true
        
        TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: false)
        bottomButton.setTitle("TaskDetailViewController.requestAuthoriztion".localized, forState: .Disabled)
    }
    
    private func hideAuthorization() {
        promptAuthorization.hidden = true
        authorizationBg.hidden = true
        waitingIcon.hidden = true
        waitingMask.hidden = true
        
        paramTable.hidden = false
        nodeTitleLabel.hidden = false
        
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
            //mod by liux at 20160912 增加了一种授权中的服务流程状态
        case ProcedureStatus.noStart.rawValue, ProcedureStatus.needAuthorize.rawValue:
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
                TaskDetailViewController.setBottomButtonEnabel(self.bottomButton, enable: false)
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
            TaskDetailViewController.setBottomButtonEnabel(vc.bottomButton, enable: false)
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
    /**
     根据是否有下一个执行节点进行下一步操作
     
     - parameter hasNextNode: 是否有下一个执行节点
     */
    func hasNextNode(hasNextNode: Bool) {
        if hasNextNode {
            clearUI()
            loadData()
        } else {
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}

extension TaskDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ParamCell") as! NodeParamTableViewCell
        
        let node = paramNodes![indexPath.row]
        cell.paramData = node
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let nodes = paramNodes {
            return nodes.count
        }
        
        return 0
    }
}
