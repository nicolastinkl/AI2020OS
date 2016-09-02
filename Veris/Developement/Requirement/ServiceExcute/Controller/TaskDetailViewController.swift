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
    @IBOutlet weak var serviceTime: IconLabel!
    @IBOutlet weak var serviceLocation: IconLabel!
    @IBOutlet weak var QRCodeImage: ServiceQRCodeView!
    @IBOutlet weak var nodeDesc: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBOutlet weak var authorizationBg: UIImageView!
    @IBOutlet weak var promptAuthorization: UILabel!
    @IBOutlet weak var waitingIcon: UIImageView!
    @IBOutlet weak var waitingMask: UIVisualEffectView!
    @IBOutlet weak var customerView: AICustomerBannerView!
    
    var serviceId: Int!
    
    private var procedure: Procedure?


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
    
    private func setupCustomerView(userModel: AICustomerModel) {
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
        titleLabel.text = "服务细节"
        self.navigationItem.titleView = titleLabel
        let backImage = UIImage(named: "se_back")
        
        let leftButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AIContestSuccessViewController.backAction(_:)))
        leftButtonItem.tintColor = UIColor.lightGrayColor()
        self.navigationItem.leftBarButtonItem = leftButtonItem
    }

    func backAction(button: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func loadData() {
        showLoading()
        
        let manager = BDKExcuteManager()
        
    //    let userId = 100000002410
        let userId = AIUser.currentUser().id
        manager.queryProcedureInstInfo(serviceId, userId: userId, success: { (responseData) in
            
            self.dismissLoading()
            self.procedure = responseData.procedure
            self.setupUI(self.procedure!)
            self.setupCustomerView(responseData.customer)
            
            }) { (errType, errDes) in
                self.dismissLoading()
                NBMaterialToast.showWithText(self.view, text: "获取数据失败".localized, duration: NBLunchDuration.SHORT)
        }
    }
    
    private func setupUI(procedure: Procedure) {
        nodeTitleLabel.text = procedure.node_info.node_title
        nodeDesc.text = procedure.node_info.node_desc
        
        if let params = procedure.param_list {
            if params.count != 0 {
                for index in 0 ..< params.count {
                    if index == 0 {
                        serviceTime.hidden = false
                        serviceTime.labelContent = params[index].value
                    } else if index == 1 {
                        serviceTime.hidden = false
                        serviceLocation.labelContent = params[index].value
                    } else {
                        break
                    }
                }
            }
        }
        
        if procedure.permission_type == PermissionType.needPermision.rawValue {
            showAuthorization()
        } else {
            hideAuthorization()
            
            
            switch procedure.status {
            case ProcedureStatus.noStart.rawValue:
                bottomButton.setTitle("TaskDetailViewController.start".localized, forState: .Normal)
                TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: true)
            case ProcedureStatus.excuting.rawValue:
                bottomButton.setTitle("TaskDetailViewController.complete".localized, forState: .Normal)
                TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: true)
            case ProcedureStatus.excuting.rawValue:
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
    }
    
    private func hideAuthorization() {
        promptAuthorization.hidden = true
        authorizationBg.hidden = true
        waitingIcon.hidden = true
        waitingMask.hidden = true
    }
    
    @IBAction func bottomButtonAction(sender: AnyObject) {
        if let p = procedure {
            switch p.status {
            case ProcedureStatus.noStart.rawValue:
                updateServiceStatus()
            case ProcedureStatus.excuting.rawValue:
                openTaskCommitViewController()
            default:
                break
                
            }
        }
    }
    
    private func updateServiceStatus() {
        let manager = BDKExcuteManager()
        
        showLoading()
        
        manager.updateServiceNodeStatus(procedure!.procedure_inst_id.integerValue, status: ProcedureStatus.excuting, success: { (responseData) in
            
            self.dismissLoading()
            
            if responseData.result_code == ResultCode.success.rawValue {
                NBMaterialToast.showWithText(self.view, text: "SubmitSuccess".localized, duration: NBLunchDuration.SHORT)
                
                self.procedure?.status = ProcedureStatus.excuting.rawValue
                self.bottomButton.setTitle("TaskDetailViewController.complete".localized, forState: .Normal)
            } else {
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
            }
            
            }) { (errType, errDes) in
                
                self.dismissLoading()
                
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
                
        }
    }
    
    private func openTaskCommitViewController() {
        let taskResultCommitlVC = TaskResultCommitViewController.initFromStoryboard()
        taskResultCommitlVC.procedureId = procedure!.procedure_inst_id.integerValue
        taskResultCommitlVC.serviceId = serviceId
        taskResultCommitlVC.delegate = self
        
        let nav = UINavigationController(rootViewController: taskResultCommitlVC)
        presentViewController(nav, animated: true, completion: nil)
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
