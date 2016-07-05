//
//  ListSubServiceCardView.swift
//  AIVeris
//
//  Created by Rocky on 16/7/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import SnapKit

class ListSubServiceCardView: UIView {

    private var cardList = [SubServiceCardView]()
    var bottomConstraint: Constraint!
    
    func setSubServicesForTest(serviceCount: Int) {
        guard serviceCount > 0 else {
            return
        }
        
        for _ in 1...serviceCount {
            let card = SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView
            let imageContent = ImageCard(frame: CGRect.zero)
            
            imageContent.imgUrl = "http://171.221.254.231:3000/upload/shoppingcart/GNcdKBip4tYnW.png"
            card.setContentView(imageContent)
            
            addSubService(card)
        }
    }
    
    func addSubService(subService: SubServiceCardView) {
        addSubview(subService)
        
        if cardList.count == 0 {
            
            subService.snp_makeConstraints(closure: { (make) in
                make.top.left.right.equalTo(self)
                self.bottomConstraint = make.bottom.equalTo(self).constraint
            })
        } else {
            let lastView = cardList.last!
            
            subService.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(lastView.snp_bottom)
                
                bottomConstraint.uninstall()
                self.bottomConstraint = make.bottom.equalTo(self).constraint
            })
        }
        
        cardList.append(subService)
    }

}
