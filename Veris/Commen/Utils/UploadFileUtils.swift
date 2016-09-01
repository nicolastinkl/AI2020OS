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
}

class LeanCloudUploadFileUtils: UploadFileUtils {
    func uploadImage(image: UIImage) -> String? {
        let data = UIImagePNGRepresentation(image)
        let file = AVFile(data: data)
        file.save()
        
        return file.url
    }
    
}