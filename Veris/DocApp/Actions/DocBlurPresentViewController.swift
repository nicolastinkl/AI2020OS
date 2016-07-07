//
//  DocBlurPresentViewController.swift
//  AIVeris
//
//  Created by zx on 7/6/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class DocBlurPresentViewController: UIViewController {
    @IBAction func buttonPressed(sender: AnyObject) {
        let vc = AIProductQAViewController()
        // CustomViewController 不需要实现任何 blur的代码
        // 初始化 CustomViewController 用任意方法初始化后调用下面一行
        presentBlurViewController(vc, animated: true, completion: nil)
    }
}
