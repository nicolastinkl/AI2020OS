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
    let timelineContainerTag: Int = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let shadow = UIImageView()
        let image = UIImage(named: "customer_order_cell_shadow")
        shadow.image = image
        addSubview(shadow)
        shadow.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    //add by liux at 20160918 增加用于处理时间线操作的delegate
    var timelineDelegate: AITimelineContentContainerViewDelegate? {
        didSet {
            guard let d = timelineDelegate else {
                return
            }
            
            for view in subviews {
                guard let sub = view.viewWithTag(timelineContainerTag) as? AITimelineContentContainerView else {
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
            
            card.loadData(modelList[i], viewModel: viewModel)

            
            if let viewModel = timelineModels[modelList[i].id] {
                let timelineContainerView = AITimelineContentContainerView(viewModel: viewModel, delegate: timelineDelegate)
                //设置tag,用于给delegate赋值
                timelineContainerView.tag = timelineContainerTag
                let caculateHeight = timelineContainerView.getCaculateHeight()
                card.setContentView(timelineContainerView, height: caculateHeight)
            }
            
            
            addSubService(card)
        }
        self.bottomConstraint.updateOffset(-15)
    }
    
    func buildContentViewModel(timelineViewModels: [String: AITimelineViewModel]) {
        timelineModels.removeAll()
        timelineModels = timelineViewModels
    }

}
