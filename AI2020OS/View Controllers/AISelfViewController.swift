//
//  AISelfViewController.swift
//  AI2020OS
//
//  Created by tinkl on 31/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import  JSONJoy

class AISelfViewController: UITableViewController {
    
    @IBOutlet var expandBgImageView: UIImageView!
    
    @IBOutlet var tableview: UITableView!

    
    private let kImageOriginHight:CGFloat = 240.0
    
    private var selfUserInfoModel:AIUserInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的"
        
        // Do any additional setup after loading the view, typically from a nib.
        selfUserInfoModel = AIUserInfoModel()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);        
        if AVUser.currentUser().mobilePhoneNumber != nil {
            
            let paras = ["phone": AVUser.currentUser().mobilePhoneNumber]
            AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.QuerUserInfoByMobileNumber, parameters: paras) {  [weak self] (response, error) -> () in
                if let re: AnyObject = response {
                    let userModel =  AIUserInfoModel(JSONDecoder(re))
                    if let strongSelf = self{
                        strongSelf.selfUserInfoModel = userModel
                        strongSelf.refereshUserData()
                    }
                }else{
                    if let strongSelf = self{
                        strongSelf.refereshUserData()
                    }
                }
            }
        }
        
    }
    
    func refereshUserData(){
        let headerview = self.tableview.tableHeaderView as UIView?
        let headerImg =  headerview?.viewWithTag(2) as AIImageView?
        let bgImg =  headerview?.viewWithTag(3) as AIImageView?
        let username =  headerview?.viewWithTag(4) as UILabel?
        bgImg?.setURL(selfUserInfoModel?.imageurl?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        headerImg?.setURL(selfUserInfoModel?.imageurl?.toURL(), placeholderImage: UIImage(named: "Placeholder"))
        headerImg?.maskWithEllipse()
        username?.text = selfUserInfoModel?.user_name ?? ""
    }
    //jump to ProviderOrder
    @IBAction func targetToOrderViewControllerAction(sender: AnyObject) {
         let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIOrderStoryboard, bundle: nil).instantiateInitialViewController() as AIOrderListViewController
        viewController.initOrderRole = viewController.ORDER_ROLE_PROVIDER
         self.navigationController?.pushViewController(viewController, animated: true)
    }
    //jump to CustomerOrder
    @IBAction func targetToCustomerOrderViewControllerAction(sender: UITapGestureRecognizer) {
        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIOrderStoryboard, bundle: nil).instantiateInitialViewController() as AIOrderListViewController
        viewController.initOrderRole = viewController.ORDER_ROLE_CUSTOMER
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    /*
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let viewTableHead: UIView = self.tableview.tableHeaderView!
        let yOffset:CGFloat   = scrollView.contentOffset.y;
        if (yOffset < -kImageOriginHight) {
            var f:CGRect = viewTableHead.frame
            f.origin.y = yOffset
            f.size.height =  -yOffset
            viewTableHead.frame = f
        }
    }*/
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row == 0 && indexPath.section == 1)
        {
            var serviceManageViewController:AIServiceManageViewController = AIServiceManageViewController()
            serviceManageViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(serviceManageViewController, animated: true)
           
           
        }
        
        
    }
    
}

