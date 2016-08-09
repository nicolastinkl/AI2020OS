//
//  AIBaseCommentView.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/9.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIBaseCommentView: UIView {

    //MARK:Vars

    var commentModel:AIBaseCommentModel?


    //MARK: func

    init(frame: CGRect, baseModel: AIBaseCommentModel) {
        super.init(frame: frame)
        commentModel = baseModel
        makeSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeSubViews() {

    }
}
