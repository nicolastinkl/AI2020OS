

//
//  AIProviderAvatarView.swift
//  AI2020OS
//
//  Created by admin on 15/5/28.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIProviderAvatarView: UIView {
    
    
    var starRating: CWStarRateView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starRating = CWStarRateView(frame: CGRect(x: 35, y: 82, width: 70, height: 10), numberOfStars: 5)
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
