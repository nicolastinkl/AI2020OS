//
//  AISettings.swift
//  AI2020OS
//
//  Created by admin on 8/27/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring

class AISettingsViewController: UIViewController{
    
    @IBOutlet weak var titleView: SpringView!
    @IBOutlet weak var containView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleView.addBottomTitleBorderLine()
    }
    
    // MARK: life cycle
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer.delegate = nil
        super.viewWillAppear(animated)
        
        //self.tabBarController?.hidesBottomBarWhenPushed = true
        //self.navigationController?.setToolbarHidden(true, animated: false)
        
    }
}


class AISettingsTableViewController:UITableViewController{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 1 {
            //logout action.
            
            let alert = UIAlertView(title: "提示", message: "确定退出登录吗", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "退出")
            alert.show()
            
            
        }
    }
}



extension AISettingsTableViewController: UIAlertViewDelegate{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            AVUser.logOut() 
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFOLogOutNotification, object: nil)

        }
    }
}