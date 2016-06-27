//
//  AIImageRecongizeService.swift
//  AIVeris
//
//  Created by zx on 6/24/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Alamofire

class AIImageRecongizeService: NSObject {
	
	func getImageInfo(image: UIImage, callback: ((AnyObject, error: Error?) -> ())?) {
		let data = UIImagePNGRepresentation(image)!
        Alamofire.upload(.POST, "http://10.5.1.249:3001/uploadAndIdentify",
                         multipartFormData: { multipartFormData in
                            multipartFormData.appendBodyPart(data: data, name: "fileUp", fileName: "file.png", mimeType: "image/png")
        },
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .Failure(let encodingError):
                debugPrint(encodingError)
            }
        })
	}
}
