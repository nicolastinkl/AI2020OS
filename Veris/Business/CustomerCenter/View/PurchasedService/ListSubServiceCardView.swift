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
    private var modelList: [ServiceOrderModel]!
    var timelineModels: [AITimelineViewModel] = []
    var bottomConstraint: Constraint!
    
    func setSubServicesForTest(serviceCount: Int) {
        guard serviceCount > 0 else {
            return
        }
        buildFakeContentViewModel()
        
        for i in 1...serviceCount {
            let card = SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView
            //let imageContent = ImageCard(frame: CGRect.zero)
            
            //imageContent.imgUrl = "http://171.221.254.231:3000/upload/shoppingcart/GNcdKBip4tYnW.png"
            //card.setContentView(imageContent)
            let timelineContainerView = AITimelineContentContainerView(viewModel: timelineModels[i-1], delegate: nil)
            let caculateHeight = timelineContainerView.getCaculateHeight()
            card.setContentView(timelineContainerView, height: caculateHeight)
            
            addSubService(card)
        }
    }
    
    func addSubService(subService: SubServiceCardView) {
        addSubview(subService)
        
        if cardList.count == 0 {
            
            subService.snp_makeConstraints(closure: { (make) in
                make.top.left.right.equalTo(self)
                self.bottomConstraint = make.bottom.equalTo(self).priority(999).constraint
            })
        } else {
            subService.hideTop()
            
            let lastView = cardList.last!
            
            subService.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(self)
                make.top.equalTo(lastView.snp_bottom)
                
                bottomConstraint.uninstall()
                self.bottomConstraint = make.bottom.equalTo(self).priority(999).constraint
            })
        }
        
        cardList.append(subService)
    }
    
    func loadData(model: ProposalOrderModel) {
        
        guard let dataList = model.service else {
            return
        }
        
        guard dataList.count > 0 else {
            return
        }
        
        modelList = dataList as! [ServiceOrderModel]
        
        buildFakeContentViewModel()
        
        
        for i in 0 ..< dataList.count {
            let card = SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView
            
            card.loadData(modelList[i], proposalData: model)

            let timelineContainerView = AITimelineContentContainerView(viewModel: timelineModels[i], delegate: nil)
            let caculateHeight = timelineContainerView.getCaculateHeight()
            card.setContentView(timelineContainerView, height: caculateHeight)
            
            addSubService(card)
        }
    }
    
    func buildFakeContentViewModel() {
        for i in 1...8 {
            timelineModels.append(AITimelineViewModel.createFakeData("\(i)"))
        }
    }

}
