//
//  AIWorkUploadPopView.swift
//  AIVeris
//
//  Created by 刘先 on 10/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//
import Spring
import UIKit
import SnapKit

class AIWorkUploadPopView: UIView {
    
    
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var popupContainerView: UIView!
    @IBOutlet weak var subContainerView: UIView!
    @IBOutlet weak var takePhotoLabel: UILabel!
    @IBOutlet weak var selectPhotoLabel: UILabel!
    
    
    @IBAction func takePhotoAction(sender: UIButton) {
    }
    
    @IBAction func choosePhotoAction(sender: AnyObject) {
    }
    
    @IBAction func cancelAction(sender: UIButton) {

        SpringAnimation.spring(0.5) {
            self.alpha = 0
            self.containerBottomConstraint.constant = -221
            self.layoutIfNeeded()
        }
    }

    //MARK: -> overrides
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    func setupViews() {
        subContainerView.layer.cornerRadius = 8
        subContainerView.layer.masksToBounds = true
    }

    static func createInstance() -> AIWorkUploadPopView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("AIWorkUploadPopView", owner: self, options: nil)!.first  as! AIWorkUploadPopView
        
        return viewThis
    }
}
