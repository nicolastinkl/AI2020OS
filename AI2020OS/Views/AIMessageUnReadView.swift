//
//  AIMessageUnReadView.swift
//  AI2020OS
//
//  Created by tinkl on 20/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIMessageUnReadView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func currentView()->AIMessageUnReadView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIMessageUnReadView, owner: self, options: nil).last  as AIMessageUnReadView
        return cell
    }
    
    @IBAction func showMessageCenterAction(sender: AnyObject) {
        let storyBoard:UIStoryboard = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIMesageCenterStoryboard, bundle: nil)
        let viewNavi = storyBoard.instantiateInitialViewController() as UINavigationController
        let rootViewConrooler = UIApplication.sharedApplication().keyWindow?.rootViewController
        rootViewConrooler?.showViewController(viewNavi, sender: nil)

    }
    
}