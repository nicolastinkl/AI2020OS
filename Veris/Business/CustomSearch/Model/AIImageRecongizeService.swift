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
				multipartFormData.appendBodyPart(data: data, name: "fileUp", fileName: "fileUp", mimeType: "image/png")
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
//data =     {
//    objectIdentificationId = 171;
//    objectList =         (
//        {
//            name = "loquat \U6787\U6777";
//            probability = "0.5316030979156494";
//        },
//        {
//            name = "longan \U9f99\U773c";
//            probability = "0.1988506466150284";
//        },
//        {
//            name = "lemon \U67e0\U6aac";
//            probability = "0.1204324141144753";
//        },
//        {
//            name = "cherry \U6a31\U6843";
//            probability = "0.05779446288943291";
//        },
//        {
//            name = "pineapple \U83e0\U841d";
//            probability = "0.04347565770149231";
//        }
//    );
//};
//desc =     {
//    "data_mode" = 0;
//    digest = "";
//    "result_code" = 1;
//    "result_msg" = ok;
//};
