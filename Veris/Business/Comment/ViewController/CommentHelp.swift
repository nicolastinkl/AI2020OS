//
//  CommentUtils.swift
//  AIVeris
//
//  Created by Rocky on 16/6/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

protocol CommentDistrictDelegate {
    func pohotImageButtonClicked(button: UIImageView, buttonParentCell: UIView)
    func appendCommentClicked(clickedButton: UIButton, buttonParentCell: UIView)
}
