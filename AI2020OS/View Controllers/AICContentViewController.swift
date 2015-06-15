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
import Cartography

// MARK: List Action's Delegate.

@objc protocol AICContentViewCellListDelegate: class {
    func listTableViewCell(cell: AICContentViewControllerCell, likeButtonPressed sender: AnyObject)
    func listTableViewCell(cell: AICContentViewControllerCell, signButtonPressed sender: AnyObject)
    func listTableViewCell(cell: AICContentViewControllerCell, exchangedButtonPressed sender: AnyObject)
}


class AICContentViewController: UITableViewController,AIConnectViewDelegate {
    
    // MARK: Priate Variable
    
    var currentModel:ConnectViewModel = ConnectViewModel.ListView
    
    private let kImageOriginHight:CGFloat = 240.0
    
    private var expandZoomImageView: AITableViewInsetMakeView{
        return AITableViewInsetMakeView.currentView()
    }
    
    lazy private var dataArray:[AIFavoriteContentModel] = {
        return []
    }()
    
    private var MainCell:String     = "MainCell"
    private var AttachedCell:String = "AttachedCell"
    
//    private var array:NSMutableArray = {
//        let dic:NSDictionary = ["Cell": "MainCell","isAttached":false]
//        return [dic,dic,dic,dic,dic,dic,dic]
//    }()
    
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()
        
        self.tableView.contentInset = UIEdgeInsetsMake(-kImageOriginHight, 0, 0, 0)
        self.expandZoomImageView.setHeight(kImageOriginHight)
        self.tableView.tableHeaderView?.addSubview(self.expandZoomImageView)
        //注册筛选消息的监听
        addFilterOberver()
    }
    
    func test(){
        
        localCode { () -> () in
            let item = AIFavoriteContentModel()
            item.favoriteTitle = "校园生活很忙"
            item.favoriteDes = "韩映社区"
            item.favoriteFromWhere = "来自澎湃新闻"
            item.favoriteTags = ["流行","美女","帅哥"]
            item.favoriteCurrentTag = "音乐"
            item.favoriteAvator = "http://mvavatar1.meitudata.com/545e65ff5ea4c884.jpg"
            item.isFavorite = 0
            item.favoriteType = FavoriteTypeEnum.music.value()
            item.favoriteFromWhereURL = "http://www.meipai.com/media/343568815"
            item.isAttached  = false
            
            var list = [AIServiceTopicModel]()
            var service = AIServiceTopicModel()
            service.service_name = "去上海出差"
            service.service_price = "123元"
            service.service_intro_url = "http://www.czgu.com/uploads/allimg/140904/0644594560-0.jpg"
            service.contents.append("机票")
            service.contents.append("住宿")
            service.contents.append("接机")
            service.contents.append("宠物寄养")
            service.isFavor = true
            service.tags.append("工作")
            
            list.append(service)
            
            service = AIServiceTopicModel()
            service.service_name = "做个柔软的胖子"
            service.service_price = "123元"
            service.service_intro_url = "http://www.wendaoyoga.com/userfiles/images/P-1.jpg"
            service.contents.append("场地")
            service.contents.append("瑜伽教练")
            service.isFavor = false
            service.tags.append("健身")
            list.append(service)
            item.serverList = list
            
            self.dataArray.append(item)
        }
        
        localCode { () -> () in
            let item = AIFavoriteContentModel()
            item.favoriteTitle = "SuSan"
            item.favoriteDes = "韩映社区"
            item.favoriteFromWhere = "来自澎湃新闻"
            item.favoriteTags = ["流行","美食"]
            item.favoriteCurrentTag = "音乐"
            item.favoriteAvator = "http://mvavatar1.meitudata.com/54108b74bb0a7773.jpg"
            item.isFavorite = 0
            item.favoriteType = FavoriteTypeEnum.music.value()
            item.favoriteFromWhereURL = "http://www.meipai.com/media/343568815"
            item.isAttached  = false
            
            var list = [AIServiceTopicModel]()
            var service = AIServiceTopicModel()
            service.service_name = "去上海出差"
            service.service_price = "123元"
            service.service_intro_url = "http://www.czgu.com/uploads/allimg/140904/0644594560-0.jpg"
            service.contents.append("机票")
            service.contents.append("住宿")
            service.contents.append("接机")
            service.contents.append("宠物寄养")
            service.isFavor = true
            service.tags.append("工作")
            
            list.append(service)
            
            item.serverList = list
            
            self.dataArray.append(item)
        }
        
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if let viewTableHead = self.tableView.tableHeaderView?.subviews.first as AITableViewInsetMakeView?{
            let yOffset:CGFloat = scrollView.contentOffset.y
            
            if yOffset < kImageOriginHight {
//                var f:CGRect = viewTableHead.frame
//                //f.origin.y = -(kImageOriginHight + (kImageOriginHight - yOffset))
//                f.size.height = kImageOriginHight + logb((kImageOriginHight - yOffset))
//                viewTableHead.frame = f
            }
            
            if (yOffset < 100) {
                viewTableHead.exchangeSuccess()
            }else{
                viewTableHead.exchangeDefault()
            }
        }
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let viewTableHead = self.tableView.tableHeaderView?.subviews.first as UIView?{
            let yOffset:CGFloat = scrollView.contentOffset.y
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
            let dict = self.dataArray[indexPath.section] as AIFavoriteContentModel
            if indexPath.row == 0 {
                // Main Cell
                
                if dict.isAttached {
                    return 140
                }else{
                    return 110
                }
            }else{
                
                // Attach Cell
                if dict.isAttached {
                    return 75
                }
                return 0
            }
            
            
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentModel == ConnectViewModel.ImageView{
            return 1
        }
        let model = self.dataArray[section] as AIFavoriteContentModel
        let count = (model.serverList?.count ?? 0) + 1
        return count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dict = self.dataArray[indexPath.section] as AIFavoriteContentModel
        if currentModel == ConnectViewModel.ImageView{
            let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerImageCell) as  AICContentViewControllerImageCell
            cell.configData(dict)
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerCell) as  AICContentViewControllerCell
                cell.configData(dict)
                cell.delegate = self
                cell.listDelegate = self
                
                if dict.isAttached {
                    cell.actionView.hidden = false
                }else{
                    cell.actionView.hidden = true
                }
                
                return cell
            }else{
                if dict.isAttached {
                    
                    let server = dict.serverList?[indexPath.row-1] as AIServiceTopicModel?
                    
                    let cell = tableView.dequeueReusableCellWithIdentifier(AIApplication.MainStoryboard.CellIdentifiers.AICContentViewControllerAttachedCell) as  AICContentViewControllerAttachedCell
                    cell.configData(server!)
                    cell.delegate = self
                    return cell
                }else{
                    return UITableViewCell()
                }
            }
        }
    }
   
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell is AICContentViewControllerCell{
            cell.addTopBorderLine()
        }
        
        cell.layoutIfNeeded()
        cell.layoutSubviews()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row > 0 {
            let controller:AIServiceDetailsViewCotnroller = self.storyboard?.instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewIdentifiers.AIServiceDetailsViewCotnroller) as AIServiceDetailsViewCotnroller
            controller.server_id = "1"
            showViewController(controller, sender: self)
        } else {
            let dict = self.dataArray[indexPath.section] as AIFavoriteContentModel
            showViewController(AIWebViewController(url: NSURL(string:  dict.favoriteFromWhereURL!)!), sender: self)
        }
        
        
    }
    
    @objc func reloadTableWithCond(notification: NSNotification){
        let userInfo:Dictionary<String,String!> = notification.userInfo as Dictionary<String,String!>
        println("notification message:" + userInfo["tagName"]! + userInfo["filterType"]!)
    }
    
    func addFilterOberver(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableWithCond:", name: "filterFlagChoose", object: nil)
        
    }
}

// MARK: datasource

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

// MARK: AICContentViewCellListDelegate

extension AICContentViewController: AICContentViewCellListDelegate{

    func listTableViewCell(cell: AICContentViewControllerCell, likeButtonPressed sender: AnyObject) {
        if let model = cell.currentModel {
            
            if model.isFavorite == 0{
                model.isFavorite = 1
            }else{
                model.isFavorite = 0
            }
            cell.refereshLikeButton()
        }
    }
    
    func listTableViewCell(cell: AICContentViewControllerCell, signButtonPressed sender: AnyObject) {
        if let model = cell.currentModel {
            
        }
    }
    
    func listTableViewCell(cell: AICContentViewControllerCell, exchangedButtonPressed sender: AnyObject) {
        if let model = cell.currentModel {
            if model.isAttached {
                model.isAttached = false
            }else{
                model.isAttached = true
            }
            self.tableView.reloadData()
            
            let animation = CATransition()
            animation.type = kCATransitionFromTop
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
            animation.duration = 0.5
            self.tableView.layer.addAnimation(animation, forKey: "UITableViewReloadDataAnimationKey")            
            
            /*
            if let indexPath = self.tableView.indexPathForCell(cell) {
            
            self.tableView.beginUpdates()
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            self.tableView.endUpdates()
            
            
            }
            */
            
        }
    }
    
}

// MARK: AICContentViewControllerCell

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
    @IBOutlet weak var like: DesignableButton!
    @IBOutlet weak var signButton: DesignableButton!
    @IBOutlet weak var moreButton: DesignableButton!
    
    @IBOutlet weak var actionView: SpringView!
    
    
    weak var listDelegate: AICContentViewCellListDelegate?
    
    var currentModel:AIFavoriteContentModel?
    
    func configData(model:AIFavoriteContentModel){
        currentModel = model
        contentImageView.setURL(NSURL(string: model.favoriteAvator! ?? ""), placeholderImage: UIImage(named: "Placeholder"))
        title.text = model.favoriteTitle! ?? ""
        descrip.text = model.favoriteDes! ?? ""
        fromWhere.text = model.favoriteFromWhere ?? ""
        signButton.setTitle(model.favoriteCurrentTag! ?? "", forState: UIControlState.Normal)

        var perButton:UIButton?
        
        if self.actionView.subviews.count  == 1{
            
            localCode { () -> () in
                var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                
                button.setTitle("全部", forState: UIControlState.Normal)
                button.titleLabel?.font = UIFont.systemFontOfSize(14)
                button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                button.layer.borderColor = UIColor.grayColor().CGColor
                button.layer.borderWidth = 0.5
                button.layer.cornerRadius = 10
                self.actionView.addSubview(button)
                button.frame = CGRectMake(0, 0, 60, 22)
                perButton = button
            }
            for item in model.favoriteTags! ?? []{
                
                var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
                button.setTitle(item, forState: UIControlState.Normal)
                button.titleLabel?.font = UIFont.systemFontOfSize(14)
                button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
                button.layer.borderColor = UIColor.grayColor().CGColor
                button.layer.borderWidth = 0.5
                button.layer.cornerRadius = 10
                actionView.addSubview(button)
                if let butt = perButton {
                    button.frame = CGRectMake(butt.left + butt.width + 10, 0, 60, 22)
                }
                perButton = button
                
            }
        }
        
        
        refereshLikeButton()
    }
    
    
    @IBAction func likeAction(sender: AnyObject) {
        listDelegate?.listTableViewCell(self, likeButtonPressed: sender)
        animateButton(like)
    }
    
    func refereshLikeButton(){
        if currentModel!.isFavorite == 0{
            like.setImage(UIImage(named: "pictureHeartLike_0"), forState: UIControlState.Normal)
        }else{
            like.setImage(UIImage(named: "pictureHeartLike_1"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func signAction(sender: AnyObject) {
        listDelegate?.listTableViewCell(self, signButtonPressed: sender)
        animateButton(signButton)
    }
    
    @IBAction func exchangedAction(sender: AnyObject) {
        listDelegate?.listTableViewCell(self, exchangedButtonPressed: sender)
        moreButton.animate()
    }
    
    func animateButton(layer: SpringButton) {
        layer.animation = "pop"
        layer.force = 1.5
        layer.animate()
    }
}



// MARK: AICContentViewControllerImageCell
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
    
    var currentModel:AIFavoriteContentModel?
    
    func shareAction() {
        
        AIApplication.shareAction("shareAction")
        
    }
    
    func editLabelAction() {
        
    }
    
    func buyAction() {
        
    }
    
    func deleteAction() {
        
    }
    
    func mutliDelAction() {
        
    }
    
    func configData(model:AIFavoriteContentModel){
        currentModel = model
        contentImageView.setURL(NSURL(string: model.favoriteAvator! ?? ""), placeholderImage: UIImage(named: "Placeholder"))
        title.text = model.favoriteTitle! ?? ""
        des.text = model.favoriteDes! ?? ""
        nick.text = model.favoriteFromWhere ?? ""
        signButton.setTitle(model.favoriteCurrentTag! ?? "", forState: UIControlState.Normal)
        avatorButton.maskWithEllipse()
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

// MARK: AICContentViewControllerAttachedCell

class AICContentViewControllerAttachedCell:MGSwipeTableCell{
    
    @IBOutlet weak var contentImage: AsyncImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    
    func configData(model: AIServiceTopicModel){
        self.contentImage.maskWithEllipse()
        contentImage.setURL(NSURL(string: model.service_intro_url!), placeholderImage: UIImage(named: "Placeholder"))
        title.text = model.service_name
        price.text = model.service_price
        
    }
    
}
