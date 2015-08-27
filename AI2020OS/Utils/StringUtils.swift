//
//  StringUtils.swift
//  AI2020OS
//
//  Created by Rocky on 15/8/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation


extension String {
    func trim() -> String {
        return stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
    }
}