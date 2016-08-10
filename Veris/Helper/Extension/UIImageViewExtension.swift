//
//  UIImageExtension.swift
//  AIVeris
//
//  Created by Rocky on 16/8/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


extension UIImageView {

    func loadFromAsset(url: NSURL) {
        
        let library = ALAssetsLibrary()
        
        library.assetForURL(url, resultBlock: { (asset) in
            
            if let asset = asset {
                let rep = asset.defaultRepresentation()
                
                if let iref = rep.fullResolutionImage() {
                    self.image = UIImage(CGImage: iref.takeRetainedValue())
                }
            }
            
            }) { (error) in
                
        }
    }
}
