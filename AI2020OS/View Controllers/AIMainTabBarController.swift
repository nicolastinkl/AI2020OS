//
//  AIMainTabBarController.swift
//  AI2020OS
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring



/*
class RAMAnimatedTabBarItem: UITabBarItem {
    
   
}

class AIMainTabBarController: UITabBarController {
    
    var iconsView: [(icon: UIImageView, textLabel: UILabel)] = Array()
    
    // MARK: life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containers = createViewContainers()
        
        createCustomIcons(containers)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"showBottomBar", name: AIApplication.Notification.UIAIASINFOWillShowBarNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector:"hiddenBottomBar", name: AIApplication.Notification.UIAIASINFOWillhiddenBarNotification, object: nil)
    }
    
    
    func showBottomBar(){
        setTabBarHidden(false, animated: true)
    }
    
    func hiddenBottomBar(){
        setTabBarHidden(true, animated: true)
    }
    
    
    // MARK Add Center button
    func addCenterButtonWithImage(buttonImage : UIImage, highlightImage : UIImage){
        var button = UIButton()
        button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
        var  heightDifference : CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        if (heightDifference < 0){
            button.center = self.tabBar.center
        }else{
            var center:CGPoint = self.tabBar.center
            center.y = center.y - heightDifference/2.0 + 10
            button.center = center
        }
        button.addTarget(self, action:"AudioSearchClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    func AudioSearchClick(sender: AnyObject?){
        // open view controller  AIAudioNavigation
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AISearchNavigation") as UINavigationController
        self.showViewController(controller, sender: self)
        
        //self.presentViewController(controller, animated: true, completion: { () -> Void in
            //controller.transitioningDelegate = TransitionManager()
        //})
    }
    // MARK: create methods
    
    func createCustomIcons(containers : NSDictionary) {
        
        if let items = tabBar.items {
            let itemsCount = tabBar.items!.count as Int
            var index = 1
            for item in self.tabBar.items as [RAMAnimatedTabBarItem] {
                
                assert(item.image != nil, "add image icon in UITabBarItem")
                
                var container : UIView = containers["container\(itemsCount-index)"] as UIView
                container.tag = index
                
                var icon = UIImageView(image: item.image)
                icon.setTranslatesAutoresizingMaskIntoConstraints(false)
                icon.tintColor = UIColor.clearColor()
                
                // text
                var textLabel = UILabel()
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clearColor()
                textLabel.textColor = item.textColor
                textLabel.font = UIFont.systemFontOfSize(10)
                textLabel.textAlignment = NSTextAlignment.Center
                textLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
                
                container.addSubview(icon)
                createConstraints(icon, container: container, size: item.image!.size, yOffset: -5)
                
                container.addSubview(textLabel)
                let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBar.items!.count) - 5.0
                createConstraints(textLabel, container: container, size: CGSize(width: textLabelWidth , height: 10), yOffset: 16)
                
                let iconsAndLabels = (icon:icon, textLabel:textLabel)
                iconsView.append(iconsAndLabels)
                
                if 1 == index { // selected first elemet
                    item.selectedState(icon, textLabel: textLabel)
                }
                
                item.image = nil
                item.title = ""
                index++
            }
        }
    }
    
    func createConstraints(view:UIView, container:UIView, size:CGSize, yOffset:CGFloat) {
        
        var constX = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0)
        container.addConstraint(constX)
        
        var constY = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: container,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: yOffset)
        container.addConstraint(constY)
        
        var constW = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.width)
        view.addConstraint(constW)
        
        var constH = NSLayoutConstraint(item: view,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: size.height)
        view.addConstraint(constH)
    }
    
    func createViewContainers() -> NSDictionary {
        
        var containersDict = NSMutableDictionary()
        let itemsCount : Int = tabBar.items!.count as Int - 1
        
        for index in 0...itemsCount {
            var viewContainer = createViewContainer()
            containersDict.setValue(viewContainer, forKey: "container\(index)")
        }
        
        var keys = containersDict.allKeys
        
        var formatString = "H:|-(0)-[container0]"
        for index in 1...itemsCount {
            formatString += "-(0)-[container\(index)(==container0)]"
        }
        formatString += "-(0)-|"
        var  constranints = NSLayoutConstraint.constraintsWithVisualFormat(formatString,
            options:NSLayoutFormatOptions.DirectionRightToLeft,
            metrics: nil,
            views: containersDict)
        view.addConstraints(constranints)
        
        return containersDict
    }
    
    func createViewContainer() -> UIView {
        var viewContainer = UIView()
        viewContainer.backgroundColor = UIColor.clearColor() // for test
        viewContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(viewContainer)
        // add gesture
        var tapGesture = UITapGestureRecognizer(target: self, action: "tapHeandler:")
        tapGesture.numberOfTouchesRequired = 1
        viewContainer.addGestureRecognizer(tapGesture)
        
        // add constrains
        var constY = NSLayoutConstraint(item: viewContainer,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: view,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0)
        
        view.addConstraint(constY)
        
        var constH = NSLayoutConstraint(item: viewContainer,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: tabBar.frame.size.height)
        viewContainer.addConstraint(constH)
        
        return viewContainer
    }
    
    // MARK: actions
    func tapHeandler(gesture:UIGestureRecognizer) {
        
        let items = tabBar.items as [RAMAnimatedTabBarItem]
        
        let currentIndex = gesture.view!.tag - 1
        if selectedIndex != currentIndex {
            var animationItem : RAMAnimatedTabBarItem = items[currentIndex]
            var icon = iconsView[currentIndex].icon
            var textLabel = iconsView[currentIndex].textLabel
            animationItem.playAnimation(icon, textLabel: textLabel)
            
            let deselelectIcon = iconsView[selectedIndex].icon
            let deselelectTextLabel = iconsView[selectedIndex].textLabel
            let deselectItem = items[selectedIndex]
            deselectItem.deselectAnimation(deselelectIcon, textLabel: deselelectTextLabel)
            
            selectedIndex = gesture.view!.tag - 1
        }
    }
    
    func isTabBarHidden()->(Bool){
        let viewFrame:CGRect = self.view.frame;
        let tabBarFrame:CGRect = self.tabBar.frame;
        return tabBarFrame.origin.y >= viewFrame.size.height;
    }
    
    func setTabBarHidden(hidden:Bool){
        setTabBarHidden(hidden, animated: false)
    }
    
    func setTabBarHidden(hidden:Bool,animated:Bool){
        UIView.animateWithDuration(0.3, animations: {
            self.tabBar.hidden = hidden
        })
         let itemsCount : Int = tabBar.items!.count as Int
         self.view.subviews.filter({(view:AnyObject)->Bool in
            let someView = view as UIView
            if someView.tag <= itemsCount && someView.tag >= 1{
                someView.hidden = hidden
            }
            return true
        })
        
    }
    
}
*/
