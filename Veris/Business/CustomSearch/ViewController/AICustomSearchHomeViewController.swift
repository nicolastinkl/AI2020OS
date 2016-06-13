//
//  AICustomSearchHomeViewController.swift
//  AIVeris
//
//  Created by 王坜 on 16/6/1.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

import UIKit
import Spring
import Cartography
import AIAlertView
import SnapKit

class AICustomSearchHomeViewController: UIViewController {


    //MARK: Private
 
    var searchBar : UISearchBar?

    //MARK: Method Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addKeyboardNotifications()

        // Make Title View
        initLayoutViews()
        
        // Make Test Data View
        let labels = AISearchHistoryLabels(frame: CGRectMake(10, 60, 300, 200), title: "测试数据", labels: ["我爱你","爱你","我爱死你啦！","我是真的真的很爱你！","滚蛋！","滚犊子！","滚一边去吧！","拜拜！"])
        view.addSubview(labels)

        // Make Wish Button
        let wishButton = UIButton(type: UIButtonType.Custom)
        wishButton.setTitle("Make a wish", forState: UIControlState.Normal)
        view.addSubview(wishButton)
        wishButton.backgroundColor = UIColor.clearColor()
        wishButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        wishButton.titleLabel?.textColor = UIColor.whiteColor()
        constrain(wishButton) { (wishProxy) in
            wishProxy.height == 30
            wishProxy.left == wishProxy.superview!.left + 10
            wishProxy.right == wishProxy.superview!.right + 10
            wishProxy.bottom == wishProxy.superview!.bottom - 5
            
        }
        wishButton.addTarget(self, action: #selector(makeAWishAction), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    //MARK: Action
    
    func makeAWishAction(){
        showTransitionStyleCrossDissolveView(AIProductInfoViewController.initFromNib())
    }
    
    /**
     init with navigation bar.
     */
    func initLayoutViews(){
        
        /// Title.
        if let navi = AINavigationBar.initFromNib() as? AINavigationBar{
            view.addSubview(navi)
            navi.holderViewController = self
            constrain(navi, block: { (layout) in
                layout.left == layout.superview!.left
                layout.top == layout.superview!.top
                layout.right == layout.superview!.right
                layout.height == 44.0 + 10.0
            })
            
            navi.titleLabel.text = ""
            
        }
        
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