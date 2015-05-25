//
//  AIServerScopeView.swift
//  AI2020OS
//
//  Created by tinkl on 22/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

struct ServerScopeModel {
    let id: String?
    let content: String?
    
    init(outId: String,outContent: String){
        self.id = outId
        self.content = outContent
    }
}

// MARK: life cycle

class AIServerScopeView: UIView {
    
    private var selectedButton: UIButton?
    
    private let tagMargin:CGFloat = 10
    
    typealias SelectedHandler = ()->(String)
    
    func initWithViewsArray(array:[ServerScopeModel],parentView:UIView){
        // Setup 1: addSubViews.
        // Setup 2: layoutIfNeeds this frame.
        var x:CGFloat = 14
        var y:CGFloat = 14
        var n = 0
        for item in array{
            var object: AnyObject =  UIButton.buttonWithType(UIButtonType.Custom)
            var button = object as UIButton
            
            button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
            
            // TODO: title Color
            button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            // TODO: Background Image
            button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Normal)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Selected)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Highlighted)
            button.addTarget(self, action: Selector("buttonDownAction:"), forControlEvents: UIControlEvents.TouchDown)
            
            button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 2
            
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
            button.associatedName = item.id!
            let value  = item.content!
            button.setTitle("\(value)", forState: UIControlState.Normal)
            let width:CGFloat  = CGFloat("\(value)".length) * 18
            
            if (x + width + tagMargin) > parentView.width {
                n = 0
                x = 24
                y += 35 + tagMargin
            }else{
                x = x + tagMargin
            }
            
            button.setSize(CGSizeMake(width, 35))
            button.setOrigin(CGPointMake(x, y))
            addSubview(button)
            x = x + width
            
            n = n + 1  // MARK: Add 1
        }
        
        self.setHeight(y+50)
    }
    
    func buttonDownAction(sender:AnyObject){
        // set self background != self.color
        let button = sender as UIButton
        
        if self.selectedButton == button{
            return
        }else{
            //disselect pre button
            disSelected(self.selectedButton!)
            // select current button
            selected(button)

        }
        self.selectedButton = button
        
    }
    
    func disSelected(buttonS: UIButton?){
        if var button = buttonS{
            
            // TODO: title Color
            button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            // TODO: Background Image
            button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Normal)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Selected)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Highlighted)
            
            
        }
    }
    
    func selected(buttonS: UIButton?){
        if var button = buttonS{
            
            // TODO: title Color
            button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Selected)
            button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            
            // TODO: Background Image
            button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Normal)
            button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Normal)
            button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Highlighted)
            
        }
    }
    
    func didSelectedItem(selectedItem:SelectedHandler){
        
    }
    
    class func currentView()->AIServerScopeView{
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIServerScopeView, owner: self, options: nil).last  as AIServerScopeView
        return cell
    }
    
}