//
//  AICustomSearchRecentlyLogoView.swift
//  AIVeris
//
//  Created by zx on 6/17/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICustomSearchRecentlyLogoView: UIView {

	var items: [String: String]
	var titleLabel: UILabel!

	init(items: [String: String]) {
		self.items = items
		super.init(frame: .zero)
		setup()
	}

	func setup() {
		titleLabel = UILabel()
//		titleLabel.font =
        titleLabel.text = "You recently searched"

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
