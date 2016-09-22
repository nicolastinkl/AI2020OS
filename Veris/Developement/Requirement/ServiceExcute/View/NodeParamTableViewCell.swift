//
//  NodeParamTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/9/22.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class NodeParamTableViewCell: UITableViewCell {

    @IBOutlet weak var iconLabel: IconLabel!
    
    var paramData: NodeParam? {
        didSet {
            guard let paramData = paramData else {
                return
            }
            
            guard let iconUrl = paramData.icon else {
                return
            }
            
            guard !iconUrl.isEmpty else {
                return
            }
            
            let url = NSURL(string: iconUrl)
            
            paramLabel?.icon.sd_setImageWithURL(url, completed: { (image, error, type, url) in
                if let im = image {
                    let scaleRate = im.size.height / self.paraIconHeight
                    let newSize = CGSize(width: im.size.width / scaleRate, height: im.size.height / scaleRate)
                    let newImage = im.resizedImageToFitInSize(newSize, scaleIfSmaller: true)
                    paramLabel?.iconImage = newImage
                } else {
                    paramLabel?.iconImage = nil
                }
            })
            
            if let iconUrl = paramData.icon {
                if !iconUrl.isEmpty {
                    
                }
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
