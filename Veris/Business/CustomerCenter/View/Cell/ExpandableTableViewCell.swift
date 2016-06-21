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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setFoldedView(view: UIView) {
        addAndSetViewHeight(view, containerView: topView, containerHeightConstraint:  topViewHeight)
    }
    
    func setBottomExpandedView(view: UIView) {
        addAndSetViewHeight(view, containerView: expandedView, containerHeightConstraint: expandedViewHeight)
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
