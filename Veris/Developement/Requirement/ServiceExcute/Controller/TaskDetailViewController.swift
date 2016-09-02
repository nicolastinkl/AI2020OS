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
    
    var serviceId: Int! = 100000000202
    var userModel: AICustomerModel!
    
    private var procedure: Procedure?
    
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
        titleLabel.text = "Service detail"
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
        view.showLoading()
        
        let manager = BDKExcuteManager()
        
        manager.queryProcedureInstInfo(serviceId, userId: AIUser.currentUser().id, success: { (responseData) in
            
            self.view.hideLoading()
            self.procedure = responseData
            self.setupUI(responseData)
            
            }) { (errType, errDes) in
                self.view.hideLoading()
                NBMaterialToast.showWithText(self.view, text: "GetDataFailed".localized, duration: NBLunchDuration.SHORT)
        }
    }
    
    private func setupUI(procedure: Procedure) {
        nodeTitleLabel.text = procedure.node_info.node_title
        nodeDesc.text = procedure.node_info.node_desc
        
        if let params = procedure.param_list {
            if params.count != 0 {
                for index in 0 ..< params.count {
                    if index == 0 {
                        serviceTime.labelContent = params[index].value
                    } else if index == 1 {
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
            TaskDetailViewController.setBottomButtonEnabel(bottomButton, enable: false)
            
            switch procedure.procedure_status {
            case ProcedureStatus.noStart.rawValue:
                bottomButton.setTitle("TaskDetailViewController.start".localized, forState: .Normal)
            case ProcedureStatus.excuting.rawValue:
                bottomButton.setTitle("TaskDetailViewController.comlete".localized, forState: .Normal)
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
            switch p.procedure_status {
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
        
        view.showLoading()
        
        manager.updateServiceNodeStatus(procedure!.procedure_inst_id.integerValue, status: ProcedureStatus.excuting, success: { (responseData) in
            
            self.view.hideLoading()
            
            if responseData.result_code == ResultCode.success.rawValue {
                NBMaterialToast.showWithText(self.view, text: "SubmitSuccess".localized, duration: NBLunchDuration.SHORT)
            } else {
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
            }
            
            }) { (errType, errDes) in
                
                self.view.hideLoading()
                
                NBMaterialToast.showWithText(self.view, text: "SubmitFailed".localized, duration: NBLunchDuration.SHORT)
                
        }
    }
    
    private func openTaskCommitViewController() {
        let taskResultCommitlVC = TaskResultCommitViewController.initFromStoryboard()
        taskResultCommitlVC.procedureId = procedure!.procedure_inst_id.integerValue
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
