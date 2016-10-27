//
//  AIWorkQualificationTableViewCell.swift
//  AIVeris
//
//  Created by 刘先 on 10/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkQualificationTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var qualificationImageView: UIImageView!
    @IBOutlet weak var qualificationLabel: UILabel!
    
    var viewModel: AIWorkQualificationBusiModel? {
        didSet {
            if let viewModel = viewModel {
                bindData(viewModel)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    func setupViews() {
        qualificationImageView.contentMode = .ScaleAspectFit
        qualificationLabel.font = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
        qualificationLabel.textColor = UIColor.whiteColor()
        self.selectionStyle = .None
    }
    
    func bindData(viewModel: AIWorkQualificationBusiModel) {
        let url = NSURL(string: viewModel.aspect_photo ?? "")
        qualificationImageView.sd_setImageWithURL(url, placeholderImage: UIImage(), options: SDWebImageOptions.RetryFailed)
        qualificationLabel.text = viewModel.type_name
    }
}
