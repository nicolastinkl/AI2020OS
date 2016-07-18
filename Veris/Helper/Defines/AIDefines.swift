//
//  AIDefines.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/30.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation


public func AILog<T>(message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        //1.对文件进行处理
        let fileName = (file as NSString).lastPathComponent
        //2.打印内容
        print("----------------------------------------------------------\n\(fileName)\n\(funcName) line: \(lineNum)\n\(message)\n----------------------------------------------------------\n")
    #endif
}
