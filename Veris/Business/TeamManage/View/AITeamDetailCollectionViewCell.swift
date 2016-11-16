//
//  AITeamDetailCollectionViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 16/11/15.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AITeamDetailCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userIconView: UIImageView!
    
    var model: AITeamDetailUserViewModel? {
        didSet {
            if let model = model {
                loadData(model)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupViews() {
        userIconView.layer.cornerRadius = userIconView.width
        userIconView.layer.masksToBounds = true
    }
    
    func loadData(model: AITeamDetailUserViewModel) {
        userNameLabel.text = model.userName
        userIconView.sd_setImageWithURL(NSURL(string: model.userIcon!), placeholderImage: UIImage(), options: SDWebImageOptions.RetryFailed)
    }

}
