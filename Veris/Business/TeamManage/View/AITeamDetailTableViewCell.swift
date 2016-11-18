//
//  AITeamDetailTableViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITeamDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    var model: AITeamDetailViewModel? {
        didSet {
            if let model = model {
                loadData(model)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    func loadData(model: AITeamDetailViewModel) {
        titleLabel.text = model.detailContent
        iconView.sd_setImageWithURL(NSURL(string: model.detailIcon!), placeholderImage: UIImage(), options: SDWebImageOptions.RetryFailed)
    }
}
