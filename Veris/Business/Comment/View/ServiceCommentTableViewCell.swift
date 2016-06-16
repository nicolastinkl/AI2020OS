//
//  ServiceCommentTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var starsContainerView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var starContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var starContainerHeightConstraint: NSLayoutConstraint!
    var starRateView: StarRateView!
    
    private var originIconHeight: CGFloat!
    private var originStarContainerHeight: CGFloat!
    private var originStarContainerWidth: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        serviceIcon.clipsToBounds = true
        
        serviceIcon.image = UIImage(named: "testHolder1")
        
        originIconHeight = heightConstraint.constant
        originStarContainerHeight = starContainerHeightConstraint.constant
        originStarContainerWidth = starContainerWidthConstraint.constant
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        if starRateView == nil {
            starRateView = StarRateView(frame: starsContainerView.frame)

            starRateView.userInteractionEnabled = true
            self.contentView.addSubview(starRateView)
            
            starRateView.snp_makeConstraints { (make) in
                make.edges.equalTo(starsContainerView)
            }
        } else {
            starRateView.frame = starsContainerView.frame
            starRateView.layoutIfNeeded()
     //       starRateView.relayoutStars()
        }
        
        serviceIcon.layer.cornerRadius = serviceIcon.height / 2
    }
    
    func setToHeadComment() {
        
        heightConstraint.constant = originIconHeight + 10
        
        starContainerHeightConstraint.constant = originStarContainerHeight + 10
        starContainerWidthConstraint.constant = originStarContainerWidth + 30
        
        contentView.layoutIfNeeded()
 
    }
    
    func setToSubComment() {
        heightConstraint.constant = originIconHeight
        
        starContainerHeightConstraint.constant = originStarContainerHeight
        starContainerWidthConstraint.constant = originStarContainerWidth
        
        contentView.layoutIfNeeded()
    }
    
}
