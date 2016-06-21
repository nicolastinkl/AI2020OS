//
//  CustomXibView.swift
//  AIVeris
//
//  Created by Rocky on 16/5/10.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

extension UIView {

    class func initFromNib() -> UIView? {

        let name = NSStringFromClass(classForCoder()).componentsSeparatedByString(".").last

        return NSBundle.mainBundle().loadNibNamed(name ?? "", owner: self, options: nil).first as? UIView
    }
    
    class func initFromNib(nibName: String) -> UIView? {
        
        return NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil).first as? UIView
    }

	// load xib file to init view, and let this custom view can be used in another xib view
	func initSelfFromXib() {
		let nibName = NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
		let view = UINib.init(nibName: nibName, bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
        insertSubview(view, atIndex: 0)
		view.snp_makeConstraints { (make) in
			make.edges.equalTo(self)
		}
	}
}
