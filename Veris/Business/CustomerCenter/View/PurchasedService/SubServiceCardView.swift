//
//  SubServiceCardView.swift
//  AIVeris
//
//  Created by Rocky on 16/6/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class SubServiceCardView: UIView {

    @IBOutlet weak var proporsalName: UILabel!
    @IBOutlet weak var messageNumber: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var statusColor: UIView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var nodeState: UILabel!
    @IBOutlet weak var nodeDate: UILabel!
    @IBOutlet weak var urgeButton: UIImageView!
    @IBOutlet weak var callButton: UIImageView!
    @IBOutlet weak var additionDescription: UILabel!
    @IBOutlet weak var addtionView: UIView!
    @IBOutlet weak var seperator: UIView!
    
    private var serviceModel: ServiceOrderModel!
    private var proposalModel: ProposalOrderModel?
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder) 
        
   //     initSelfFromXib()
        
   //     initSubView()
    }
    
    override func awakeFromNib() {
        initSubView()
    }
    
    
    func urgeBtnTap(sender: UITapGestureRecognizer) {
        

    }

    func callBtnTap(sender: UITapGestureRecognizer) {
        
    }
    
    func setContentView(view: UIView, height: CGFloat) {
        addtionView.addSubview(view)
        
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(addtionView)
            make.height.equalTo(height)
        }
        
        setNeedsUpdateConstraints()
    }
    
    func hideTop() {
        proporsalName.text = nil
        proporsalName.removeFromSuperview()
        messageNumber.removeFromSuperview()
        statusButton.removeFromSuperview()
        statusColor.removeFromSuperview()
        
        seperator.hidden = true
    }
    
    func loadData(serviceData: ServiceOrderModel, proposalData: ProposalOrderModel? = nil) {
        if let pro = proposalData {
            proposalModel = pro
            proporsalName.text = pro.name
            messageNumber.text = "\(pro.messages)"
            statusButton.titleLabel?.text = pro.state
        }
        
        
        serviceModel = serviceData
        
        serviceName.text = serviceData.name
        if let serUrl = serviceData.image {
            serviceIcon.asyncLoadImage(serUrl)
        }
        
        if let node = serviceData.node {
            nodeName.text = node.procedure_inst_name
      //      nodeDate.text = node.time
            nodeState.text = node.status
            
            if let url = serviceData.provider_icon {
                personIcon.asyncLoadImage(url, placeHoldImg: "contact_icon")

            }
            
            if node.procedure_inst_desc != nil {
                additionDescription.text = node.procedure_inst_desc
            }
        }
    }
    
    private func initSubView() {
        serviceIcon.makeRound()
        personIcon.makeRound()
        
        proporsalName.font = CustomerCenterConstants.Fonts.CustomerOrderTitle
        messageNumber.font = CustomerCenterConstants.Fonts.CustomerOrderBadge
        messageNumber.makeRound()
        statusButton.makeRound()
        statusButton.titleLabel?.font = CustomerCenterConstants.Fonts.CustomerOrderStatus
        
//        leftButton.makeRound()
//        rightButton.makeRound()
//        rightButton.layer.borderColor = UIColor(hex: "#0f86e8").CGColor
//        rightButton.layer.borderWidth = 1
        
        
        addtionView.updateConstraints()
        
        urgeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SubServiceCardView.urgeBtnTap(_:))))
        callButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SubServiceCardView.callBtnTap(_:))))
        
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        nodeName.font = CustomerCenterConstants.Fonts.CustomerOrderTaskName
        additionDescription.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        nodeState.font = CustomerCenterConstants.Fonts.CustomerOrderTaskStatus
        nodeDate.font = CustomerCenterConstants.Fonts.CustomerOrderTaskName

    }
    
}
