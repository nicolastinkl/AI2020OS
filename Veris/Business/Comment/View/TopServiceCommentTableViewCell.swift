//
//  TopServiceCommentTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/27.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class TopServiceCommentTableViewCell: ServiceCommentTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(60))
        firstComment.hint.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        firstComment.inputTextView.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        appendComment.inputTextView.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
    }

}
