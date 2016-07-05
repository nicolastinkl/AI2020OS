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
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var nodeName: UILabel!
    @IBOutlet weak var nodeState: UILabel!
    @IBOutlet weak var nodeDate: UILabel!
    @IBOutlet weak var urgeButton: UIImageView!
    @IBOutlet weak var callButton: UIImageView!
    @IBOutlet weak var additionDescription: UILabel!
    @IBOutlet weak var addtionView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var additionalViewHeight: NSLayoutConstraint!
 
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
    
    func setContentView(view: UIView) {
        
    }
    
    private func initSubView() {
        serviceIcon.makeRound()
        personIcon.makeRound()
        
        proporsalName.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(60))
        messageNumber.makeRound()
        statusButton.titleLabel?.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(39))
        
        leftButton.makeRound()
        rightButton.makeRound()
        rightButton.layer.borderColor = UIColor(hex: "#0f86e8").CGColor
        rightButton.layer.borderWidth = 1
        
        additionalViewHeight.constant = 0
        addtionView.updateConstraints()
        
        urgeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SubServiceCardView.urgeBtnTap(_:))))
        callButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SubServiceCardView.callBtnTap(_:))))
        
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        nodeName.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        additionDescription.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        nodeState.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(39))
        nodeDate.font = AITools.myriadLightSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
    }
    
}
