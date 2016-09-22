//
//  NodeParamTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/9/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class NodeParamTableViewCell: UITableViewCell {
    
    private static let paraIconHeight: CGFloat = 20

    @IBOutlet weak var iconLabel: IconLabel!
    
    var paramData: NodeParam? {
        didSet {
            guard let paramData = paramData else {
                return
            }
            
            iconLabel.labelContent = paramData.value
            
            guard let iconUrl = paramData.icon else {
                return
            }
            
            guard !iconUrl.isEmpty else {
                return
            }
            
            let url = NSURL(string: iconUrl)
            
            iconLabel.icon.sd_setImageWithURL(url, completed: { (image, error, type, url) in
                if let im = image {
                    let scaleRate = im.size.height / NodeParamTableViewCell.paraIconHeight
                    let newSize = CGSize(width: im.size.width / scaleRate, height: im.size.height / scaleRate)
                    let newImage = im.resizedImageToFitInSize(newSize, scaleIfSmaller: true)
                    self.iconLabel.iconImage = newImage
                } else {
                    self.iconLabel.iconImage = nil
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }   
    
}
