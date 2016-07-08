//
//  AICutomSearchHomeResultFilterBar.swift
//  AIVeris
//
//  Created by zx on 7/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICutomSearchHomeResultFilterBar: UIView {
    @IBOutlet var filterButtons: [ImagePositionButton]!
    @IBOutlet var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.15 )
        
        filterButtons.forEach { (b) in
            b.titleLabel?.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
            b.setTitleColor(UIColor.yellowColor(), forState: .Selected)
            b.addTarget(self, action: #selector(AICutomSearchHomeResultFilterBar.buttonPressed(_:)), forControlEvents: .TouchUpInside)
            b.updateImageInset()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelfFromXib()
    }
    
    func buttonPressed(sender: UIButton) {
        filterButtons.forEach { b in
//           b.
        }
    }
}
