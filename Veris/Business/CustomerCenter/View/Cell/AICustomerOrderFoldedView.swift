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
//    @IBOutlet weak var taskSchedulTimeLabel: UILabel!
//    @IBOutlet weak var taskStatusLabel: UILabel!
	@IBOutlet weak var taskNameLabel: UILabel!
	@IBOutlet weak var providerIcon: UIImageView!
	@IBOutlet weak var statusButton: UIButton!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var noticeBadgeLabel: DesignableLabel!
	@IBOutlet weak var proposalName: UILabel!
	
	lazy var taskSchedulTimeLabel: UILabel = { [unowned self] in
		let result = UILabel()
		result.textColor = UIColor.whiteColor()
		self.addSubview(result)
		return result
	}()
	lazy var taskStatusLabel: UILabel = { [unowned self] in
		let result = UILabel()
		result.textColor = UIColor.whiteColor()
		self.addSubview(result)
		return result
	}()
	
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
	
	override func updateConstraints() {
		taskSchedulTimeLabel.snp_updateConstraints { (make) in
			make.centerY.equalTo(taskNameLabel)
			make.trailing.equalTo(statusLabel)
		}
		
		taskStatusLabel.snp_updateConstraints { (make) in
			make.centerY.equalTo(taskNameLabel)
			if taskSchedulTimeLabel.text?.length > 0 {
				make.trailing.equalTo(taskSchedulTimeLabel.snp_leading)
			} else {
				make.trailing.equalTo(statusLabel)
			}
		}
		
		super.updateConstraints()
	}
	
	func setupViews() {
		let buttonBgImage = UIColor(hexString: "#ffffff", alpha: 0.15).imageWithColor()
		statusButton.setBackgroundImage(buttonBgImage, forState: UIControlState.Normal)
		statusButton.layer.cornerRadius = 10
		statusButton.layer.masksToBounds = true
//        statusButton.titleLabel?.font = CustomerCenterConstants.Fonts.CustomerOrderStatus
		statusLabel.font = CustomerCenterConstants.Fonts.CustomerOrderStatus
		
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
		
		statusLabel.text = proposalStateViewModel.stateName
//        statusButton.setTitle(proposalStateViewModel.stateName, forState: UIControlState.Normal)
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
					
					// mod by Shawn at 20160818
					taskNameLabel.text = serviceData.node.procedure_inst_name
				}
			}
		}
	}
	
	private func getHasNodeService(orders: [ServiceOrderModel]) -> ServiceOrderModel? {
		for order in orders {
			if order.node != nil && order.node.procedure_inst_id != nil {
				return order
			}
		}
		
		return nil
	}
	
	// MARK: currentView
	class func currentView() -> AICustomerOrderFoldedView {
		let selfView = NSBundle.mainBundle().loadNibNamed("AICustomerOrderFoldedView", owner: self, options: nil).first as! AICustomerOrderFoldedView
		return selfView
	}
	
}

protocol AIFoldedCellViewDelegate {
	func statusButtonDidClick(proposalModel: ProposalOrderModel)
}
