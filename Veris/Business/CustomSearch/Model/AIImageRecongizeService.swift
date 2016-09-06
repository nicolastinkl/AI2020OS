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
	
	static let fakeMapper = [
		[
			"inputs": [
				"围兜",
				"奶嘴",
				"奶桶",
				"小床",
				"尿布",
			],
			"output": "孕"
		],
		
		[
			"inputs": [
				"出租车",
			],
			"output": "车"
		],
		[
			"inputs": [
				"救护车"
			],
			"output": "挂号"
		],
	]
	
	static func resultConvertFromFakeMapper(input: String) -> String {
        var result = input
        for item in fakeMapper {
            let inputs = item["inputs"] as! [String]
            if inputs.contains(input) {
                result = item["output"] as! String
                AILog("转换成功")
                AILog(result)
                break
            }
        }
        return result
	}
	
	func getImageInfo(image: UIImage, callback: ((String?, error: Error?) -> ())?) {
		let data = UIImagePNGRepresentation(image)!
		let url = AIApplication.AIApplicationServerURL.uploadAndIdentify.description
		Alamofire.upload(.POST, url,
			multipartFormData: { multipartFormData in
				multipartFormData.appendBodyPart(data: data, name: "fileUp", fileName: "fileUp", mimeType: "image/png")
			},
			encodingCompletion: { encodingResult in
				let failblock = {
					if let callback = callback {
						let e = Error(message: "无法解析", code: 2)
						callback(nil, error: e)
					}
				}
				switch encodingResult {
				case .Success(let upload, _, _):
					upload.responseJSON { response in
						if let res = response.result.value as? NSDictionary {
							AILog(res)
							if let objectList = res["data"]?["objectList"] as? NSArray {
								if objectList.count > 0 {
									let firstItem = objectList.firstObject as! NSDictionary
									if let name = firstItem["name"] as? String {
										if let result = name.componentsSeparatedByString(" ").first {
                                            let fakeResult = AIImageRecongizeService.resultConvertFromFakeMapper(result)
											callback?(fakeResult, error: nil)
										} else {
											failblock()
										}
									} else {
										failblock()
									}
								} else {
									failblock()
								}
							} else {
								failblock()
							}
						} else {
							failblock()
						}
						debugPrint(response)
					}
				case .Failure(let encodingError):
					failblock()
					debugPrint(encodingError)
				}
		})
	}
	
}
