//
//  AICContentViewController.swift
//  AI2020OS
//
//  Created by tinkl on 3/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit
import Spring

class AICContentViewController: UITableViewController,AIConnectViewDelegate {
    
    // MARK: Priate Variable
    
    var currentModel:ConnectViewModel = ConnectViewModel.ListView
    
    private let kImageOriginHight:CGFloat = 240.0
    
    private var expandZoomImageView: UIView{
        return AITableViewInsetMakeView.currentView()
    }
    
    private var MainCell:String     = "MainCell"
    private var AttachedCell:String = "AttachedCell"
    
    private var array:NSMutableArray = {
        let dic:NSDictionary = ["Cell": "MainCell","isAttached":false]
        return [dic,dic,dic,dic,dic,dic,dic]
    }()
    
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-kImageOriginHight, 0, 0, 0)
        self.expandZoomImageView.setHeight(kImageOriginHight)
        self.tableView.tableHeaderView?.addSubview(self.expandZoomImageView)
        //注册筛选消息的监听
        addFilterOberver()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let viewTableHead = self.tableView.tableHeaderView?.subviews.first as UIView?{
            let yOffset:CGFloat = scrollView.contentOffset.y
            if (yOffset < kImageOriginHight) {
//                var f:CGRect = viewTableHead.frame
//                //f.origin.y = -(kImageOriginHight + (kImageOriginHight - yOffset))
//                f.size.height =  kImageOriginHight + sin((kImageOriginHight - yOffset))
//                viewTableHead.frame = f
            }
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let viewTableHead = self.tableView.tableHeaderView?.subviews.first as UIView?{
            let yOffset:CGFloat = scrollView.contentOffset.y
            println(yOffset)
            if (yOffset < 100) {
                let viewContr = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIVideoStoryboard, bundle: nil).instantiateInitialViewController() as UIViewController
                self.showViewController(viewContr, sender: self)
            }
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AIConnectView.sharedManager.delegates.append(self)
        
        
    }
    
    // MARK: event response    
    
    
    func exchangeViewModel(viewModel: ConnectViewModel, selection: CollectSelection) {
        
        self.currentModel = viewModel
        
        self.tableView.reloadData()
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if currentModel == ConnectViewModel.ImageView{
            return 290
        }else{
            let dict = self.array[indexPath.row] as NSDictionary
            if (dict["Cell"] as String) == self.MainCell {
                return 110
            }
            return 75
        }
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return array.count
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if currentModel == ConnectViewModel.ImageView{
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerImageCell) as  AICContentViewControllerImageCell
            cell.configData()
            return cell
        }else{
            let dict = self.array[indexPath.row] as NSDictionary
            if (dict["Cell"] as String) == self.MainCell {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerCell) as  AICContentViewControllerCell
                cell.configData()
                cell.delegate = self
                return cell
                
            }else if (dict["Cell"] as String) == self.AttachedCell {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerAttachedCell) as  AICContentViewControllerAttachedCell
                cell.configData()
                cell.delegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
   
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if currentModel == ConnectViewModel.ImageView{
        
        }else{
            var path:NSIndexPath?
            
            let dict = self.array[indexPath.row] as NSDictionary
            if (dict["Cell"] as String) == self.MainCell {
                path = NSIndexPath(forItem: (indexPath.row+1), inSection: indexPath.section)
            }else{
                path = indexPath
            }
            if let bol = dict["isAttached"] as? Bool {
                if bol {
                    let dic:NSDictionary = ["Cell": "MainCell","isAttached":false]
                    self.array[path!.row-1] = dic
                    self.array.removeObjectAtIndex(path!.row)
                    
                    self.tableView.beginUpdates()
                    self.tableView.deleteRowsAtIndexPaths([path!], withRowAnimation: UITableViewRowAnimation.Top)
                    self.tableView.endUpdates()
                    
                    
                }else{
                    
                    let dic:NSDictionary = ["Cell": "MainCell","isAttached":true]
                    self.array[path!.row-1] = dic
                    let addDic:NSDictionary = ["Cell": "AttachedCell","isAttached":true]
                    self.array.insertObject(addDic, atIndex: path!.row)
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRowsAtIndexPaths([path!], withRowAnimation: UITableViewRowAnimation.Top)
                    self.tableView.endUpdates()
                    
                }
            }
        }
        
        
    }
    
    @objc func reloadTableWithCond(notification: NSNotification){
        let selValue = notification.object as String
        println("notification message:" + selValue)
    }
    
    func addFilterOberver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableWithCond:", name: "filterFlagChoose", object: nil)
        
    }
}


extension AICContentViewController: MGSwipeTableCellDelegate{
    
    func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings!, expansionSettings: MGSwipeExpansionSettings!) -> [AnyObject]! {
        
        swipeSettings.transition = MGSwipeTransition.Border
        expansionSettings.buttonIndex = 0
        
        if direction == MGSwipeDirection.LeftToRight {
            expansionSettings.fillOnTrigger = false
            expansionSettings.threshold = 2
            return []
        }else{
            expansionSettings.fillOnTrigger = true
            expansionSettings.threshold = 1.1
            let padding:Int = 15

            if cell.reuseIdentifier! == AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerCell {
                
                let trash = MGSwipeButton(title: "删除", backgroundColor: UIColor.redColor(), padding: padding, callback: { (cell) -> Bool in
                    let indexpath: NSIndexPath = self.tableView.indexPathForCell(cell as AICContentViewControllerCell)!
                    //                self.tableView.deleteRowsAtIndexPaths([indexpath], withRowAnimation: UITableViewRowAnimation.Left)
                    return false
                })
                
                let edit = MGSwipeButton(title: "编辑", backgroundColor: UIColor(red: 1.0, green: 149/255, blue: 0.05, alpha: 1), padding: padding, callback: { (cell) -> Bool in
                    return true
                })
                
                return [trash,edit]
            }else if cell.reuseIdentifier! == AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerAttachedCell{
                
                let edit = MGSwipeButton(title: "收藏", backgroundColor: UIColor(hex: "#436CD1"), padding: padding, callback: { (cell) -> Bool in
                    return true
                })
                return [edit]
            }
            
            
            return []
        }
    }
    
    func swipeTableCell(cell: MGSwipeTableCell!, didChangeSwipeState state: MGSwipeState, gestureIsActive: Bool) {
        
        
    }
}

/*!
*  @author tinkl, 15-06-03 11:06:13
*
*  list model
*/
class AICContentViewControllerCell: MGSwipeTableCell{
    
    @IBOutlet weak var contentImageView: AsyncImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var fromWhere: UILabel!
    @IBOutlet weak var like: UIButton!
    @IBOutlet weak var signButton: DesignableButton!
    @IBOutlet weak var moreButton: UIButton!
    
    func configData(){
        contentImageView.setURL(NSURL(string: "http://imglf0.ph.126.net/2PAScdjOGW7u_SF8n_YA0Q==/6630531204025177476.jpg"), placeholderImage: UIImage(named: "Placeholder"))
        title.text = "Cafe Del Mar是Ibiza最为出名的地方"
        descrip.text = "这是一座可以从海水看到日落倒影的海岸咖啡馆,面朝夕阳无限好的橘色日落景象 ,结合令人心旷神怡的Lounge音乐"
        fromWhere.text = "来自网易轻博客"
    }
}

/*!
*  @author tinkl, 15-06-03 11:06:13
*
*  Image push model
*/
class AICContentViewControllerImageCell: UITableViewCell,AITabelViewMenuViewDelegate{
    
    @IBOutlet weak var contentImageView: AIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var signButton: DesignableButton!
    @IBOutlet weak var avatorButton: AsyncButton!
    @IBOutlet weak var nick: UILabel!
    @IBOutlet weak var des: UILabel!
    @IBOutlet weak var menuView: UIView!
    
    func shareAction() {
        
    }
    
    func editLabelAction() {
        
    }
    
    func buyAction() {
        
    }
    
    func deleteAction() {
        
    }
    
    func mutliDelAction() {
        
    }
    
    func configData(){
        contentImageView.setURL(NSURL(string: "http://imglf0.ph.126.net/2PAScdjOGW7u_SF8n_YA0Q==/6630531204025177476.jpg"), placeholderImage: UIImage(named: "Placeholder"))
        title.text = "Cafe Del Mar是Ibiza最为出名的地方"
        des.text = "这是一座可以从海水看到日落倒影的海岸咖啡馆,面朝夕阳无限好的橘色日落景象 ,结合令人心旷神怡的Lounge音乐"
        nick.text = "南方在线"
        avatorButton.maskWithEllipse()
        signButton.setTitle("网易", forState: UIControlState.Normal)
    }
    
    @IBAction func moreAction(sender: AnyObject) {
        if menuView.subviews.first != nil{
            let cview = menuView.subviews.first as AITabelViewMenuView
            cview.animation = "zoomOut"
            cview.animate()
            Async.userInitiated(after: 0.5, block: { () -> Void in
                cview.removeFromSuperview()
            })
            
        }else{
            let menu = AITabelViewMenuView.currentView()
            menu.delegate = self
            menuView.addSubview(menu)
        }
        
    }
    
    @IBAction func signAction(sender: AnyObject) {
    
    }
    
}

class AICContentViewControllerAttachedCell:MGSwipeTableCell{
    
    @IBOutlet weak var contentImage: AsyncImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    func configData(){
        self.contentImage.maskWithEllipse()
        contentImage.setURL(NSURL(string: "http://imglf0.ph.126.net/2PAScdjOGW7u_SF8n_YA0Q==/6630531204025177476.jpg"), placeholderImage: UIImage(named: "Placeholder"))
        title.text = "Cafe Del Mar是Ibiza最为出名的地方"
        price.text = "1380元"
        
    }
    
}
