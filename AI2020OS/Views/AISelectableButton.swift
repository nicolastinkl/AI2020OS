//
//  AISelectableButton.swift
//  AI2020OS
//
//  Created by admin on 15/8/14.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit



class AISelectableButton: UIButton {
    
    let DEFAULT_COLOR = "#ffffff"
    let SELECTED_COLOR = AIApplication.AIColor.MainSystemBlueColor
    let DEFAULT_TITLE_COLOR = AIApplication.AIColor.MainSystemBlueColor
    let SELECTED_TITLE_COLOR = "#ffffff"
    
    var delegate: SelectableButtonDelegate?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initCreate()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initCreate()
    }
    
    private func initCreate() {
        addTarget(self, action: Selector("didTapButton:"), forControlEvents: .TouchUpInside)
        
        setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: DEFAULT_COLOR)), forState: UIControlState.Normal)
        setBackgroundImage(UIImage.imageWithColor(UIColor(rgba: SELECTED_COLOR)), forState: UIControlState.Selected)
        
        setTitleColor(UIColor(rgba: DEFAULT_TITLE_COLOR), forState: UIControlState.Normal)
        setTitleColor(UIColor(rgba: SELECTED_TITLE_COLOR), forState: UIControlState.Selected)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgba: SELECTED_COLOR).CGColor

    }
    
    @IBAction private func didTapButton(button: UIView!) {
        selected = !selected
        delegate?.buttonSelectedChanged(self, isSelected: selected)
    }
    
    func setNormalBackground(backgroundImage: UIImage) {
        setBackgroundImage(backgroundImage, forState: UIControlState.Normal)
    }
    
    func setSelectedBackground(backgroundImage: UIImage) {
        setBackgroundImage(backgroundImage, forState: UIControlState.Selected)
    }
}

protocol SelectableButtonDelegate {
    func buttonSelectedChanged(button: AISelectableButton, isSelected: Bool)
}
