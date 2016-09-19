//
//  ImageLineView.swift
//  AIVeris
//
//  Created by Rocky on 16/9/19.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ImageLineView: UIView {

    @IBInspectable var lineImage: UIImage? {
        set {
            
            if let image = newValue {
                let lineImage = UIColor(patternImage: image)
                backgroundColor = lineImage
            }
        }
        
        get {
            return self.lineImage
        }
    }

}
