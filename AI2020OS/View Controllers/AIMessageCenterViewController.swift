//
//  AIMessageCenterViewController.swift
//  AI2020OS
//
//  Created by tinkl on 21/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AIMessageCenterViewController: UIViewController {

    // MARK: swift controls
    @IBOutlet weak var toolBarView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: IM VARS
    var im:AIIMCenter?
    
    var storage:AIIMStorage?
    
    var rooms: NSMutableArray?
    
    var notify: AIIMNotify?
    
    
    // MARK: life cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.rooms = NSMutableArray()
        self.im = AIIMCenter.sharedManager
        self.notify = AIIMNotify.sharedManager
        self.storage = AIIMStorage.sharedManager
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.toolBarView.addBottomGreenBorderLine()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navigationbar-white"), forBarMetrics: UIBarMetrics.Default)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        notify?.addMessageObserver(self, selector: "refresh")
        self.im?.addObserver(self, forKeyPath: "connect", options: NSKeyValueObservingOptions.New, context: nil)
        
        Async.userInitiated {
            self.refresh()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.im?.removeObserver(self, forKeyPath: "connect")
        notify?.removeMessageObserver(self)
        
    }
    
    func refresh(){
        self.im?.findRecentRoomsWithBlock({ (objects, error) -> Void in
            if (error != nil) {
                self.rooms = NSMutableArray(array: objects)
                self.tableView.reloadData()
                
                // set unread numbers
                
            }
        })
    }
   

    // MARK: event response
    @IBAction func moreAction(sender: AnyObject) {
        showMenuViewController()        
    }
    
    @IBAction func userAction(sender: AnyObject) {
//    UIfetchViewContrller
    }
    
    @IBAction func backViewAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Key Path
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
      
        if keyPath == "status" && self.im! == object as NSObject{
            // update status view
        }
    }
    
}

extension AIMessageCenterViewController: UITableViewDataSource,UITableViewDelegate{

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rooms?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AITMSGSDContentViewCell) as AITMSGSDContentViewCell
        
        //configureCell(cell, atIndexPath:indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 115
    }
}