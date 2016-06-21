//
//  SubServiceCardView.swift
//  AIVeris
//
//  Created by Rocky on 16/6/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class SubServiceCardView: UIView {

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
    
    private func initSubView() {
        serviceIcon.makeRound()
        personIcon.makeRound()
        
        leftButton.layer.cornerRadius = leftButton.height / 2
        rightButton.layer.cornerRadius = rightButton.height / 2
        
        additionalViewHeight.constant = 0
        addtionView.updateConstraints()
        
        urgeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SubServiceCardView.urgeBtnTap(_:))))
        callButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SubServiceCardView.callBtnTap(_:))))
    }
    
}
