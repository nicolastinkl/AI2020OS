//
//  AIImageViewUtils.swift
//  AI2020OS
//
//  Created by admin on 15/8/18.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Spring

class AIImageViewUtils {
    class func loadImageFromUrl(imageView: UIImageView, url: String, placeholderImage: UIImage) {
        ImageLoader.sharedLoader.imageForUrl(url) { [weak imageView] image, url in
            if let strongSelf = imageView {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    strongSelf.alpha = 0.2;
                    strongSelf.image = image
                    UIView.beginAnimations(nil, context: nil)
                    UIView.setAnimationDuration(0.5)
                    strongSelf.setNeedsDisplay()
                    strongSelf.alpha = 1;
                    UIView.commitAnimations()
                })
            }
        }

    }
}
