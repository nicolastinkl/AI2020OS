//
//  AIRoundImageView.swift
//  AI2020OS
//
//  Created by Rocky on 15/8/11.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIRoundImageView : UIImageView {
    

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        maskWithEllipse()
    }

}
