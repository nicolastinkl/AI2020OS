//
//  AIPopupSContainerView.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/26.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class AIPopupSContainerView: UIView {

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    

    @IBAction func closeAction(sender: UIButton) {
        dismiss()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    static func createInstance() -> AIPopupSContainerView {
        let nib = NSBundle.mainBundle().loadNibNamed("AIPopupSContainerView", owner: self, options: nil)
        if let nib = nib {
            let selfView = nib.first as! AIPopupSContainerView
            return selfView
        } else {
            return AIPopupSContainerView()
        }
        
        
    }
    
    func buildContent(subView: UIView) {
        contentView.addSubview(subView)
        subView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    func setupViews() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    //MARK: Public
    
    func dismiss() {
        SpringAnimation.spring(0.5) {
            self.alpha = 0
            self.containerBottomConstraint.constant = -221
            self.layoutIfNeeded()
        }
    }
}

