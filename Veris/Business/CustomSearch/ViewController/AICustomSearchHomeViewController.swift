//
//  AICustomSearchHomeViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICustomSearchHomeViewController: UIViewController {


    //MARK: Private


    var searchBar : UISearchBar?




    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        addKeyboardNotifications()


        let labels = AISearchHistoryLabels(frame: CGRectMake(10, 20, 300, 200), title: "测试数据", labels: ["我爱你","爱你","我爱死你啦！","我是真的真的很爱你！","滚蛋！","滚犊子！","滚一边去吧！","拜拜！"])



        self.view.addSubview(labels)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    //MARK: Keyboard Notification

    func addKeyboardNotifications() {

    }


    //MARK: SearchBar
    func addSearchBar() {

    }

}





extension AICustomSearchHomeViewController : UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }


    func textViewDidEndEditing(textView: UITextView) {
        
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return true
    }

}