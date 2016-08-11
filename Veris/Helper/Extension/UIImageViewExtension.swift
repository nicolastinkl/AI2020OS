//
//  UIImageExtension.swift
//  AIVeris
//
//  Created by Rocky on 16/8/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Photos


extension UIImageView {

    func loadFromAsset(url: NSURL) {
        
//        let library = ALAssetsLibrary()
//        
//        library.assetForURL(url, resultBlock: { [weak self] (asset)  in
//            
//            if let asset = asset {
//                let rep = asset.defaultRepresentation()
//                
//                if let iref = rep.fullResolutionImage() {
//                    self?.image = UIImage(CGImage: iref.takeRetainedValue())
//                }
//            }
//            
//            }) { (error) in
//                
//        }
        
        let assets = PHAsset.fetchAssetsWithALAssetURLs([url], options: nil)
        
        let asset = assets.firstObject as! PHAsset
        
        let scale = UIScreen.mainScreen().scale
        let thumbnailSize = CGSize(width: width * scale, height: height * scale)
        
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: thumbnailSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: {  [weak self] image, _ in
            if let im = image {
                self?.image = im
            }
            
        })
    
    }
}
