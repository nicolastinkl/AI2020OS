//
//  NSFoundation+Completion.swift
//  AIVeris
//
//  Created by zx on 8/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

extension String {
	var length: Int {
		return characters.count
	}
    
    var count: Int {
        return length
    }
}

extension SequenceType {
	public func reject(@noescape exludesElement: (Self.Generator.Element) throws -> Bool) rethrows -> [Self.Generator.Element] {
		return try filter(exludesElement)
	}
	
	public func each(@noescape body: (Self.Generator.Element) throws -> Void) rethrows {
		return try forEach(body)
	}
}

extension Array {

}
