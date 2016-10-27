//
//  AIBCDetailView.swift
//  AIVeris
//
//  Created by 刘先 on 16/10/25.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIBCDetailView: UIView {

    static func createInstance() -> AIBCDetailView {
        let viewThis = NSBundle.mainBundle().loadNibNamed("AIBCDetailView", owner: self, options: nil)!.first  as! AIBCDetailView
        
        return viewThis
    }

}
