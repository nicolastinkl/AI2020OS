//
//  SKSTableViewCell.swift
//  SKSTableView
//
//  Created by Rocky on 2016/10/19.
//  Copyright © 2016年 sakkaras. All rights reserved.
//

import UIKit

class SKSTableViewCell: UITableViewCell {
    
    static var buttonBackgroundImage: UIImage!
    
    private var _isExpandable: Bool = false
    
    var isExpandable: Bool {
        set {
            _isExpandable = newValue
            
            if newValue {
                accessoryView = createExpandableView()
            }
        }
        
        get {
            return _isExpandable
        }
    }
    
    var isExpanded = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        isExpanded = false
        isExpandable = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isExpanded = false
        isExpandable = true
    }
    
    func createExpandableView() -> UIView? {
        if SKSTableViewCell.buttonBackgroundImage == nil {
            SKSTableViewCell.buttonBackgroundImage = UIImage(named: "expandableImage.png")
        }

        let button = UIButton(type: .Custom)
        let frame = CGRect(x: 0, y: 0, width: SKSTableViewCell.buttonBackgroundImage.size.width, height: SKSTableViewCell.buttonBackgroundImage.size.height)
        button.setBackgroundImage(SKSTableViewCell.buttonBackgroundImage, forState: .Normal)
        
        button.frame = frame
        
        return button
    }
    
    func accessoryViewAnimation() {
      
        UIView.animateWithDuration(0.2, animations: { 
            if self.isExpanded {
                self.accessoryView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            } else {
                self.accessoryView?.transform = CGAffineTransformMakeRotation(0)
            }
            }) { (finished) in
                
        }
  
    }

}
