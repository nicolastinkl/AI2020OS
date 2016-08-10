//
//  AssertUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/8/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AssetUtils {
    class func assetExists(url: NSURL) -> Bool {
        
        let WDASSETURL_PENDINGREADS = 1
        let WDASSETURL_ALLFINISHED = 0
        
        var exists = false
        
        
        let albumReadLock = NSConditionLock(condition: WDASSETURL_PENDINGREADS)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.assetForURL(url, resultBlock: { (asset) in
                
                exists = asset != nil
                albumReadLock.lock()
                albumReadLock.unlockWithCondition(WDASSETURL_ALLFINISHED)
                
                }, failureBlock: { (error) in
                    albumReadLock.lock()
                    albumReadLock.unlockWithCondition(WDASSETURL_ALLFINISHED)
            })
        }
        
        albumReadLock.lockWhenCondition(WDASSETURL_ALLFINISHED)
        albumReadLock.unlock()
        
        return exists
    }
    
//    class func loadImagesFromAssets(urls: [NSURL]) -> [UIImage]? {
//        var images: [UIImage]!
//        
//        // [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:MyURL]]];
//        for url in urls {
//            guard let d = NSData(contentsOfURL: url) else {
//                continue
//            }
//            
//            guard let image = UIImage(data: d) else {
//                continue
//            }
//            
//            if images == nil {
//                images = [UIImage]()
//            }
//            
//            images.append(image)
//        }
//        
//        return images
//    }
}
