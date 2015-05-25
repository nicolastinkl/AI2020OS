//
//  AIComponentChoseViewController.swift
//  AI2020OS
//
//  Created by tinkl on 22/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIComponentChoseViewController: UIViewController {
    
    // MARK: swift controls
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    private let margeheight:CGFloat = 20
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK TITLE
        
        var title = UILabel()
        title.text = "服务范围"
        title.setWidth(self.view.width)
        title.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        title.setHeight(30)
        title.setLeft(25)
        title.setTop(20)
        self.contentScrollView.addSubview(title)
        
        // MARK CONTENT
        let scopeView =  AIServerScopeView.currentView()
        scopeView.initWithViewsArray([
            ServerScopeModel(outId: "2", outContent: "一居室 90元一次"),
            ServerScopeModel(outId: "6", outContent: "居室 9D"),
            ServerScopeModel(outId: "3", outContent: "两室 190元一次SDF"),
            ServerScopeModel(outId: "5", outContent: "两室 190DF次"),
            ServerScopeModel(outId: "7", outContent: "两室 190元")], parentView: self.view)
        self.contentScrollView.addSubview(scopeView)
        scopeView.setTop(title.height + title.top)
        
        // MARK LINE
        var line =  UILabel()
        line.setWidth(self.view.width*0.9)
        line.setHeight(0.5)
        line.setTop(scopeView.height + scopeView.top)
        line.setLeft((self.view.width - line.width)/2)
        line.backgroundColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        self.contentScrollView.addSubview(line)
        
        // MARK TITLE
        var title2 = UILabel()
        title2.text = "服务时间"
        title2.setWidth(self.view.width)
        title2.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        title2.setHeight(30)
        title2.setLeft(25)
        title2.setTop(line.top+margeheight)
        self.contentScrollView.addSubview(title2)
        
        // MARK CONTENT
        
        var timePickerView = AIServerTimeView.currentView()
        self.contentScrollView.addSubview(timePickerView)
        timePickerView.setTop(title2.height + title2.top)
        
        // MARK LINE
        var line2 =  UILabel()
        line2.setWidth(self.view.width*0.9)
        line2.setHeight(0.5)
        line2.setTop(timePickerView.height + timePickerView.top + 50)
        line2.setLeft((self.view.width - line2.width)/2)
        line2.backgroundColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        self.contentScrollView.addSubview(line2)
        
        // MARK TITLE
        var title3 = UILabel()
        title3.text = "服务地址"
        title3.setWidth(self.view.width)
        title3.textColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        title3.setHeight(30)
        title3.setLeft(25)
        title3.setTop(line2.top+margeheight)
        self.contentScrollView.addSubview(title3)

        var addressPickerView = AIServerAddressView.currentView()
        self.contentScrollView.addSubview(addressPickerView)
        addressPickerView.setTop(title3.height + title3.top)
        
        // MARK LINE
        var line3 =  UILabel()
        line3.setWidth(self.view.width*0.9)
        line3.setHeight(0.5)
        line3.setTop(addressPickerView.height + addressPickerView.top + 50)
        line3.setLeft((self.view.width - line3.width)/2)
        line3.backgroundColor = UIColor(rgba: AIApplication.AIColor.MainSystemBlackColor)
        self.contentScrollView.addSubview(line3)
        self.contentScrollView.contentSize = CGSizeMake(self.view.width, line3.top+10)
        
        
    }
    
    
    // MARK: event response
    @IBAction func disMissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}