//
//  AICustomerOrderFoldedView.swift
//  AIVeris
//
//  Created by 刘先 on 16/7/4.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AICustomerOrderFoldedView: UIView {
    
    
    @IBOutlet weak var statusColorView: UIView!
    @IBOutlet weak var taskSchedulTimeLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var providerIcon: UIImageView!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var noticeBadgeLabel: DesignableLabel!
    @IBOutlet weak var proposalName: UILabel!
    
    var delegate: AIFoldedCellViewDelegate?
    var proposalModel: ProposalOrderModel!
    
    
    @IBAction func ServiceDetailAction(sender: UIButton) {
        if let delegate = delegate {
            delegate.statusButtonDidClick(proposalModel!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    func setupViews() {
        let buttonBgImage = UIColor(hexString: "#ffffff", alpha: 0.15).imageWithColor()
        statusButton.setBackgroundImage(buttonBgImage, forState: UIControlState.Normal)
        statusButton.layer.cornerRadius = 10
        statusButton.layer.masksToBounds = true
        statusButton.titleLabel?.font = CustomerCenterConstants.Fonts.CustomerOrderStatus
        
        noticeBadgeLabel.layer.cornerRadius = 8
        noticeBadgeLabel.layer.masksToBounds = true
        noticeBadgeLabel.font = CustomerCenterConstants.Fonts.CustomerOrderBadge
        
        proposalName.font = CustomerCenterConstants.Fonts.CustomerOrderTitle
        taskSchedulTimeLabel.font = CustomerCenterConstants.Fonts.CustomerOrderTaskName
        taskStatusLabel.font = CustomerCenterConstants.Fonts.CustomerOrderTaskStatus
        taskNameLabel.font = CustomerCenterConstants.Fonts.CustomerOrderTaskName
    }
    
    func loadData(proposalViewModel: ProposalOrderViewModel) {
        self.proposalModel = proposalViewModel.model
        let proposalStateViewModel = proposalViewModel.proposalState!
        
        
        
        statusButton.setTitle(proposalStateViewModel.stateName, forState: UIControlState.Normal)
        statusColorView.backgroundColor = proposalStateViewModel.color
        proposalName.text = proposalModel.name
        noticeBadgeLabel.text = "\(proposalModel.messages)"
        taskStatusLabel.text = proposalModel.state
        
        if let services = proposalModel.service as? [ServiceOrderModel] {
            if services.count > 0 {
                if let serviceData = getHasNodeService(services) {
                    if let time = ProposalOrderViewModel.getNodeTime(serviceData.node) {
                        taskSchedulTimeLabel.text = "\(time)"
                    }
                    
                    if let url = serviceData.provider_icon {
                        providerIcon.asyncLoadImage(url, placeHoldImg: "contact_icon")
                        
                    }
                    
                    //mod by Shawn at 20160818
                    taskNameLabel.text = serviceData.node.procedure_inst_name
                }
            }
        }
    }
    
    private func getHasNodeService(orders: [ServiceOrderModel]) -> ServiceOrderModel? {
        for order in orders {
            if order.node != nil {
                return order
            }
        }
        
        return nil
    }

    // MARK: currentView
    class func currentView() -> AICustomerOrderFoldedView {
        let selfView = NSBundle.mainBundle().loadNibNamed("AICustomerOrderFoldedView", owner: self, options: nil).first  as! AICustomerOrderFoldedView
        return selfView
    }

}

protocol AIFoldedCellViewDelegate {
    func statusButtonDidClick(proposalModel: ProposalOrderModel)
}
