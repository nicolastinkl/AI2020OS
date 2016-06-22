//
//  ExpandableTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/20.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var expandedView: UIView!
    @IBOutlet weak var expandedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    var expandedContentView: UIView?
    var topContentView: UIView?
    
    var isExpanded: Bool = false {
        willSet {
            if newValue == isExpanded {
                return
            }
            if newValue {
                if let ex = expandedContentView {
                    expandedView.addSubview(ex)
                    ex.snp_makeConstraints { (make) in
                        make.edges.equalTo(expandedView)
                    }
                }
            } else {
                expandedContentView?.removeFromSuperview()
            }

        }

//        didSet {
//            if oldValue == isExpanded {
//                return
//            }
//            if isExpanded {
//                if let ex = expandedContentView {
//                    expandedViewHeight.active = false
//                    expandedView.addSubview(ex)
//                    ex.snp_makeConstraints { (make) in
//                        make.edges.equalTo(expandedView)
//                    }
//                }
//            } else {
//                expandedViewHeight.active = true
//                expandedContentView?.removeFromSuperview()
//                expandedViewHeight.constant = 0
//            }
//            expandedView.updateConstraints()
//            contentView.layoutIfNeeded()
//        }
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        isExpanded = false
//    }

    func setFoldedView(view: UIView) {
        topContentView = view
        addAndSetViewHeight(view, containerView: topView, containerHeightConstraint:  topViewHeight)
    }

    func setBottomExpandedView(view: UIView) {
        expandedContentView = view
//        addAndSetViewHeight(view, containerView: expandedView, containerHeightConstraint:  expandedViewHeight)
    }

    private func addAndSetViewHeight(view: UIView, containerView: UIView, containerHeightConstraint: NSLayoutConstraint) {
        containerHeightConstraint.constant = view.height

        containerView.addSubview(view)
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }

        containerView.updateConstraints()
    }
}
