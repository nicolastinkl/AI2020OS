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
    
    let DEFAULT_HEIGHT: CGFloat = 35
    let DEFAULT_LEFT_MARGIN: CGFloat = 14
    var buttonSize: CGSize?
    var dataSource: AIServerScopeViewDataSource?
    
    private var selectedButton: UIButton?
    private var scopeArray: [ServerScopeModel]!
    
    var tagMargin: CGFloat = 10
    var leftMargin: CGFloat = 14
    
    typealias SelectedHandler = ()->(String)
    
    func initWithViewsArray(array: [ServerScopeModel], parentView: UIView){
        scopeArray = array
        addUIControls(scopeArray.count, parentView: parentView)
    }
    
    func buttonDownAction(sender:AnyObject){

        let button = sender as UIButton
        
        button.selected = !button.selected
        
        if selectedButton != button {
            selectedButton?.selected = false
        }
        
        if button.selected {
            selected(button)
        } else {
            disSelected(button)
        }
        
        self.selectedButton = button
        
    }
    
    func disSelected(buttonS: UIButton?){

    }
    
    func selected(buttonS: UIButton?) {

    }
    
    func didSelectedItem(selectedItem:SelectedHandler){
        
    }
    
    // 重新加载数据
    func reload(parentView: UIView) {
        if dataSource != nil {
            
            for subview in subviews {
                subview.removeFromSuperview()
            }
            
            let sd = dataSource!
            
            let count = sd.numberOfCell(self)
            
            addUIControls(count, parentView: parentView)
        }
    }
    
    class func currentView()->AIServerScopeView {
        var cell = NSBundle.mainBundle().loadNibNamed(AIApplication.MainStoryboard.ViewIdentifiers.AIServerScopeView, owner: self, options: nil).last  as AIServerScopeView
        return cell
    }
    
    // 创建一个默认风格的tag控件
    func defaultTagStyleButton() -> UIButton {
        
        var object: AnyObject =  UIButton.buttonWithType(UIButtonType.Custom)
        var button = object as UIButton
        
        button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        
        // TODO: title Color
        button.setTitleColor(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Selected)
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        
        // TODO: Background Image
        button.setBackgroundImage(UIColor.whiteColor().imageWithColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Selected)
        button.setBackgroundImage(UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).imageWithColor(), forState: UIControlState.Highlighted)
        button.addTarget(self, action: Selector("buttonDownAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        button.layer.borderColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlueColor).CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        
        return button
    }
    
    private func createUIControl(index: Int) -> UIControl {
        var control: UIControl!
        if dataSource == nil {
            control = defaultTagStyleButton()
        } else {
            control = dataSource!.scopeView(self, cellForItemAtIndex: index)
        }
    
        return control
    }
    
    // 将控件添加到ServerScopeView中. count：控件的数量
    private func addUIControls(count: Int, parentView: UIView) {
        var x:CGFloat = leftMargin
        var y:CGFloat = 14
        var n = 0
        
        
        
        for var index = 0; index < count; ++index {
            var uiControl = createUIControl(index)
               
            if dataSource == nil {
                let value  = scopeArray[index].content!
                var button = uiControl as UIButton
                
                button.associatedName = scopeArray[index].id!
                
                button.setTitle("\(value)", forState: UIControlState.Normal)
            }
            
            var size: CGSize!
            if buttonSize == nil {
                var button = uiControl as UIButton
                let width: CGFloat  = CGFloat("\(button.titleLabel?.text)".length) * 7
                
                size = CGSizeMake(width, DEFAULT_HEIGHT)
            } else {
                size = buttonSize!
            }
            
            if (x + size.width + tagMargin) > (parentView.width - 50) {
                n = 0
                x = leftMargin
                y += size.height + tagMargin
            } else {
                if n > 0 {
                    x = x + tagMargin
                }
            }
            
            n = n + 1  // MARK: Add 1
            
            uiControl.setSize(size)
            uiControl.setOrigin(CGPointMake(x, y))
            addSubview(uiControl)
            x = x + size.width
        }
        
        self.setHeight(y + 50)
    }
    
}

protocol AIServerScopeViewDataSource {
    // 标签控件的数量
    func numberOfCell(scopeView: AIServerScopeView) -> Int
    // 要求AIServerScopeViewDataSource返回一个UIControl，显示在AIServerScopeView中，cellForItemAtIndex是这个UIControl在AIServerScopeView的位置
    func scopeView(scopeView: AIServerScopeView, cellForItemAtIndex: Int) -> UIControl
}