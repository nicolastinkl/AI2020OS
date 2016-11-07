//
//  AIMemberCardContentView.swift
//  AIVeris
//
//  Created by zx on 11/4/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIMemberCardContentView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var iconURL: String? {
        didSet {
            if let url = iconURL {
                let encode = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                imageView.sd_setImageWithURL(NSURL(string: encode))
            }
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 10
        titleLabel.font = AITools.myriadRegularWithSize(60.displaySizeFrom1242DesignSize())
        titleLabel.textColor = UIColor.whiteColor()
        
    } 
}
