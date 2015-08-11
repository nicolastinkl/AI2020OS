

//
//  AIProviderAvatarView.swift
//  AI2020OS
//
//  Created by admin on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProviderAvatarView: UITableViewCell {
    
    
    @IBOutlet weak var avatar: UIImageView!
    
    var avatarImg: UIImageView {
        get {
            return avatar
        }
    }
    
    var starRating: CWStarRateView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        avatar.maskWithEllipse()
        
        setWidth(CGFloat(140))
        setHeight(CGFloat(140))
        starRating = CWStarRateView(frame: CGRect(x: 40, y: 72, width: 60, height: 10), numberOfStars: 5)
        addSubview(starRating!)
        
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
