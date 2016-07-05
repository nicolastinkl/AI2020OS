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
    @IBOutlet weak var proporalNameLabel: UILabel!
    
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
        
        noticeBadgeLabel.layer.cornerRadius = 8
        noticeBadgeLabel.layer.masksToBounds = true
    }
    
    func loadData(proposalModel: ProposalOrderModel) {
        self.proposalModel = proposalModel
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
