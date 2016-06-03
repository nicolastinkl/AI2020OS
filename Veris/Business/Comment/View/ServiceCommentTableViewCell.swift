//
//  ServiceCommentTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCommentTableViewCell: UITableViewCell {

    var starRateView: CWStarRateView!
    @IBOutlet weak var starsContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        if starRateView == nil {
            starRateView = CWStarRateView(frameAndImage: starsContainerView.frame, numberOfStars: 5, foreground: "review_star_yellow", background: "review_star_gray")
            starRateView.userInteractionEnabled = true
            self.contentView.addSubview(starRateView)
            
            starRateView.snp_makeConstraints { (make) in
                make.edges.equalTo(starsContainerView)
            }
        }
    }
    
}
