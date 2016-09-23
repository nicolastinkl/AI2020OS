//
//  NSFoundation+Completion.swift
//  AIVeris
//
//  Created by zx on 8/8/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

public extension String {
	var length: Int {
		return characters.count
	}
    
    var count: Int {
        return length
    }

    var floatValue: Float {
        return (self as NSString).floatValue
    }
}


public extension SequenceType {
	public func reject(@noescape exludesElement: (Self.Generator.Element) throws -> Bool) rethrows -> [Self.Generator.Element] {
		return try filter(exludesElement)
	}
	
	public func each(@noescape body: (Self.Generator.Element) throws -> Void) rethrows {
		return try forEach(body)
	}
}

public extension Array {

}

public extension Dictionary {
    mutating func addEntriesFromDictionary(dictionary: Dictionary) {
        for (key, value) in dictionary {
            self.updateValue(value, forKey:key)
        }
    }
}

public extension Int {
    public func toString() -> String {
        return String(self)
    }
}
