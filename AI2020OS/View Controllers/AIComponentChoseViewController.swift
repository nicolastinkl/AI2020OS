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
    }
    
    
    // MARK: event response
    @IBAction func disMissViewController(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}