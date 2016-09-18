//
//  UploadFileUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/8/31.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol UploadFileUtils {
    func uploadImage(image: UIImage) -> String?
    func uploadFile(filePathUrl: NSURL) -> String?
}

class LeanCloudUploadFileUtils: UploadFileUtils {
    func uploadImage(image: UIImage) -> String? {
        //let data = UIImagePNGRepresentation(image)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            
            let file = AVFile(data: data)
            file.saveInBackgroundWithBlock({ (complate, error) in
                if complate {
                    AILog("LeanCloudUploadFileUtils OK")
                } else {
                    AILog("LeanCloudUploadFileUtils \(error)")
                }
                
                
            })
            
            return file.url
        }
        return ""
    }
    
    func uploadFile(filePathUrl: NSURL) -> String? {
        guard let data = NSData(contentsOfURL: filePathUrl) else {
            return nil
        }
        
        let file = AVFile(data: data)
        file.save()
        
        return file.url
    }
    
}
