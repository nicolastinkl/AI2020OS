//
//  ImageCard.swift
//  AIVeris
//
//  Created by Rocky on 16/7/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring

class ImageCard: UIImageView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentMode = .ScaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imgUrl: String? {
        didSet {
            if let url = imgUrl {
                ImageLoader.sharedLoader.imageForUrl(url) {	 (image, url) -> () in
                    if let img = image {
                        self.image = img
                        
                        self.snp_updateConstraints(closure: { (make) in
                            make.height.equalTo(self.snp_width).multipliedBy(img.size.height / img.size.width)
                        })
                    }
                }
            }    
        }
    }

}
