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
    var timelineModels = [String: AITimelineViewModel]()
    var bottomConstraint: Constraint!
    var delegate: SubServiceCardViewDelegate? {
        didSet {
            guard let d = delegate else {
                return
            }
            
            for view in subviews {
                guard let sub = view as? SubServiceCardView else {
                    continue
                }
                
                sub.delegate = d
            }
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
    
    func loadData(viewModel: ProposalOrderViewModel) {
        
        guard let dataList = viewModel.model.service else {
            return
        }
        
        guard dataList.count > 0 else {
            return
        }
        
        
        modelList = dataList as! [ServiceOrderModel]
        
        //add by Shawn at 0819
        if let timelineViewModels = viewModel.timelineViewModels {
            buildContentViewModel(timelineViewModels)
        }
        
        
        
        for i in 0 ..< dataList.count {
            let card = SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView
            
            card.loadData(modelList[i], proposalData: viewModel.model)

            
            if let viewModel = timelineModels[modelList[i].id] {
                let timelineContainerView = AITimelineContentContainerView(viewModel: viewModel, delegate: nil)
                let caculateHeight = timelineContainerView.getCaculateHeight()
                card.setContentView(timelineContainerView, height: caculateHeight)
            }
            
            
            addSubService(card)
        }
    }
    
    func buildContentViewModel(timelineViewModels: [String: AITimelineViewModel]) {
        timelineModels.removeAll()
        timelineModels = timelineViewModels
    }

}
