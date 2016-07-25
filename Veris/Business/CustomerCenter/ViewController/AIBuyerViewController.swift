//
//  AIBuyerViewController.swift
//  AIVeris
//
//  Created by 王坜 on 15/10/20.
//  Copyright © 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import Spring


/// Proprosal 详情页
class AIBuyerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AIBuyerDetailDelegate {

    // MARK: - Properties

    var dataSource  = [ProposalOrderModelWrap]()
    var dataSourcePop = [AIBuyerBubbleModel]()
    var tableViewCellCache = NSMutableDictionary()

    var bubbles: AIBubblesView!

    var curBubbleCenter: CGPoint?

    var curBubbleScale: CGFloat?

    var originalViewCenter: CGPoint?

    // MARK: - Constants

    let bubblesTag: NSInteger = 9999

    let progressLabelTag = 321

    let screenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width

    let tableCellRowHeight: CGFloat = AITools.displaySizeFrom1080DesignSize(240)

    let topBarHeight: CGFloat = AITools.displaySizeFrom1080DesignSize(130)

    // MARK: - Variable
    private var panGestureStartY: CGFloat = 0
    private var panGestureThresholdYVelocity: CGFloat = 50
    private var panGestureMaxBeginYOffset: CGFloat = 0.33 * CGRectGetHeight(UIScreen.mainScreen().bounds)
    private var offsetableWindowYOffset: CGFloat = 0.80 * CGRectGetHeight(UIScreen.mainScreen().bounds)
    
    private lazy var bubbleViewContainer: UIView = {
        // Create Bubble View of Top.
        let height = CGRectGetHeight(self.view.bounds) - AITools.displaySizeFrom1080DesignSize(116)
        return UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, height))
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = UIColor.clearColor()
        return  tableView
    }()

    var topBar: UIView!

    var didRefresh: Bool?

    var popTableView: UIView = UIView()
    
    private let BUBBLE_VIEW_MARGIN = AITools.displaySizeFrom1080DesignSize(40)

    private let BUBBLE_VIEW_HEIGHT = AITools.displaySizeFrom1080DesignSize(1538)

    var lastSelectedIndexPath: NSIndexPath?

    private var selfViewPoint: CGPoint?
    var maxBubbleViewController: UIViewController?
    
    private let proposalTableViewController = AIProposalTableViewController()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        selfViewPoint = self.view.center

        self.makeBaseProperties()

        self.makeTableView()

        self.makeTopBar()

        // Add Pull To Referesh..
        setupLanguageNotification()

        setupUIWithCurrentLanguage()

        initMakePopTableView()
        
        if AILoginUtil.isLogin() {
            self.tableView.headerBeginRefreshing()
        }
        view.addSubview(popTableView)
        
        popTableView.frame = view.frame
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Async.main(after: 0.3) {
            if self.popTableView.subviews.count == 0 {
                let navigationViewController = UINavigationController(rootViewController: self.proposalTableViewController)
                navigationViewController.navigationBarHidden = true
                //TODO: 这里要改成导航切换，还有BUG所以暂时没穿入导航VC
                self.addSubViewController(self.proposalTableViewController, toView: self.popTableView)
                self.finishPanDownwards(self.popTableView, velocity: 0)
            }
            
        }
    }
    
    // MARK: -> Internal methods
    func addSubViewController(viewController: UIViewController, toView: UIView? = nil) {
        self.addChildViewController(viewController)
        toView?.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        viewController.view.pinToEdgesOfSuperview()
    }
    
    func initMakePopTableView() {
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(AIBuyerViewController.didRecognizePanGesture(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
    /**
     滑动手势
     */
    func didRecognizePanGesture(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            panGestureStartY = popTableView.frame.origin.y
            fallthrough
        case .Changed:
            let translation = panGestureStartY + recognizer.translationInView(popTableView).y
            popTableView.setY(translation)
        case .Ended:
            fallthrough
        case.Cancelled:
            let velocity = recognizer.velocityInView(popTableView).y
            if abs(velocity) >= 50 { // TODO make threshold velocity configurable
                if velocity > 0 {
                    finishPanDownwards(popTableView, velocity: velocity)
                } else {
                    finishPanUpwards(popTableView, velocity: velocity)
                }
            } else {
                if popTableView.frame.origin.y >= 0.5 * CGRectGetWidth(UIScreen.mainScreen().bounds) {
                    finishPanDownwards(popTableView, velocity: velocity)
                } else {
                    finishPanUpwards(popTableView, velocity: velocity)
                }
            }
        default:
            break // Nothing to do when failed/possible
        }
    }
    
    func finishPanUpwards(window: UIView, velocity: CGFloat) {
        proposalTableViewController.tableView.userInteractionEnabled = true
        SpringAnimation.spring(0.5) { 
            window.setY(0)
        }                
    }
    
    func finishPanDownwards(window: UIView, velocity: CGFloat) {
        // Settings Pan Disabled.
        
        proposalTableViewController.tableView.userInteractionEnabled = false
        SpringAnimation.spring(0.5) {
            window.setY(self.offsetableWindowYOffset)
        }
    }
    
    // MARK: - 构造列表区域
    func makeTableView () {

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20

        tableView.registerClass(AITableFoldedCellHolder.self, forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITableFoldedCellHolder)

        tableView.registerNib(UINib(nibName: "ExpandableTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandableTableViewCell")

        view.addSubview(tableView)

        tableView.tableHeaderView = bubbleViewContainer

    }

    func setupLanguageNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIBuyerViewController.setupUIWithCurrentLanguage), name: LCLLanguageChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIBuyerViewController.refreshAfterNewOrder), name: AIApplication.Notification.UIAIASINFORecoverOrdersNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIBuyerViewController.refreshAfterNewOrder), name: AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
    }

    func refreshAfterNewOrder () {

        weak var ws = self
        Async.main(after: 0.2) { () -> Void in
            ws!.tableView.headerBeginRefreshing()
        }
    }
 

    func setupUIWithCurrentLanguage() {
        //TODO: reload data with current language

        //remake bubble
//        let label = bubbleViewContainer.viewWithTag(progressLabelTag) as? UILabel
//        label?.text = "AIBuyerViewController.progress".localized

        // reset refresh view
        tableView.removeHeader()
        weak var weakSelf = self
        tableView.addHeaderWithCallback { () -> Void in

            weakSelf!.clearPropodalData()
            weakSelf!.loadData()
        }

        tableView.addHeaderRefreshEndCallback { () -> Void in
            weakSelf!.tableView.reloadData()

        }

        // reload bottom tableView
        tableViewCellCache.removeAllObjects()
        tableView.reloadData()

    }


    func cleanHistoryData () {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.buyerListData = nil
        appDelegate.buyerProposalData = nil
        /**
        Clear self data.
        */
        self.dataSourcePop = []
        self.dataSource = []
        self.tableView.reloadData()
    }

    func loadData() {

        self.tableView.hideErrorView()


        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let listData: ProposalOrderListModel? = appDelegate.buyerListData
        let proposalData: AIProposalPopListModel? = appDelegate.buyerProposalData
        weak var weakSelf = self
        if listData != nil && proposalData != nil {
            Async.main(after: 0.3, block: { () -> Void in
                weakSelf!.parseListData(listData)
                weakSelf!.parseProposalData(proposalData)
                appDelegate.buyerListData = nil
                appDelegate.buyerProposalData = nil
                weakSelf?.tableView.reloadData()

            })

        } else {
            let bdk = BDKProposalService()
            // 列表数据
            
            /*
             var listDone = false
             var bubblesDone = false
             
            bdk.getProposalList({ (responseData) -> Void in
                listDone = true
                weakSelf!.didRefresh = true
                weakSelf!.parseListData(responseData)

                if bubblesDone {
                    weakSelf!.tableView.headerEndRefreshing()
                }


                }, fail: { (errType, errDes) -> Void in
                    weakSelf!.didRefresh = false
                    weakSelf!.tableView.headerEndRefreshing()
            })
             */

            //气泡数据
            
            bdk.getPoposalBubbles({ (responseData) in
                self.didRefresh = true
                self.parseProposalData(responseData)
                self.tableView.headerEndRefreshing()
                }, fail: { (errType, errDes) in
                    self.didRefresh = false
                    self.tableView.headerEndRefreshing()
            })
  
        }
    }


    deinit {
        tableViewCellCache.removeAllObjects()
    }


    // MARK: - 构造属性
    func makeBaseProperties () {
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBarHidden = true


        let bgImageView = UIImageView(image: UIImage(named: "Buyer_topBar_Bg"))
        bgImageView.frame = self.view.frame
        self.view.addSubview(bgImageView)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIBuyerViewController.reloadDataAfterUserChanged), name: kShouldUpdataUserDataNotification, object: nil)
    }

    func handleUserChangeEvent () {
        clearPropodalData()

        if let b = bubbles {
            b.removeFromSuperview()
        }

        if let _ : UITableView = tableView {
            tableView.reloadData()
            tableView.removeFromSuperview()

            tableView.registerClass(AITableFoldedCellHolder.self, forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITableFoldedCellHolder)

            self.view.insertSubview(tableView, belowSubview: self.topBar)

            tableView.tableHeaderView = self.bubbleViewContainer
            tableView.headerBeginRefreshing()
        }

    }


    func reloadDataAfterUserChanged() {

        weak var ws = self
        Async.main(after: 0.2) { () -> Void in
            ws!.handleUserChangeEvent()
        }
    }

    private func clearPropodalData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.buyerListData = nil
        appDelegate.buyerProposalData = nil
        tableViewCellCache.removeAllObjects()
        dataSourcePop = []
        dataSource.removeAll()
        tableView.reloadData()
        // reset UI
    }


    // 回调
    func closeAIBDetailViewController() {

        if curBubbleScale != nil && curBubbleScale != nil {

            self.view.userInteractionEnabled = false
            self.view.transform = CGAffineTransformMakeScale(curBubbleScale!, curBubbleScale!)
            self.view.center = curBubbleCenter!

            UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                self.view.transform = CGAffineTransformMakeScale(1, 1)
                self.view.center = self.originalViewCenter!
                }) { (Bool) -> Void in
                    self.view.userInteractionEnabled = true
            }

        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }


    }


    func makeBubblesWithFrame(frame: CGRect) -> AIBubblesView {

        // add bubbles
        bubbles = AIBubblesView(frame: frame, models: NSMutableArray(array: self.dataSourcePop))
        bubbles.tag = bubblesTag
        bubbleViewContainer.addSubview(bubbles)

        weak var wf = self
        bubbles.addGestureBubbleAction {(bubbleModel, bubble) -> Void in

            if bubbleModel.bubbleType == 2 {
                wf!.showAddNewBubble(bubble, model: bubbleModel)
            } else {
                wf!.showBuyerDetailWithBubble(bubble, model: bubbleModel)
            }


        }

        return bubbles
    }


    func makeBubbleView () {
        if let _ = bubbles {
            recreateBubbleView()
        } else {
            createBubbleView()
        }
    }

    private func recreateBubbleView() {
        bubbles.removeFromSuperview()
        bubbles = nil

        makeBubblesWithFrame(CGRectMake(BUBBLE_VIEW_MARGIN, topBarHeight + BUBBLE_VIEW_MARGIN, screenWidth - 2 * BUBBLE_VIEW_MARGIN, BUBBLE_VIEW_HEIGHT))
    }

    private func createBubbleView() {

        // add bubbles
        makeBubblesWithFrame(CGRectMake(BUBBLE_VIEW_MARGIN, topBarHeight + BUBBLE_VIEW_MARGIN, screenWidth - 2 * BUBBLE_VIEW_MARGIN, BUBBLE_VIEW_HEIGHT))
/*
        let y = CGRectGetMaxY(bubbles.frame)
        let label: UPLabel = AIViews.normalLabelWithFrame(CGRectMake(BUBBLE_VIEW_MARGIN, y, screenWidth - 2 * BUBBLE_VIEW_MARGIN, 20), text: "AIBuyerViewController.progress".localized, fontSize: 20, color: UIColor.whiteColor())
        label.textAlignment = .Right
        label.tag = progressLabelTag

        label.verticalAlignment = UPVerticalAlignmentMiddle
        label.font = AITools.myriadRegularWithSize(20)
        bubbleViewContainer.addSubview(label)*/
    }

    func convertPointToScaledPoint(point: CGPoint, scale: CGFloat, baseRect: CGRect) -> CGPoint {
        var scaledPoint: CGPoint = CGPoint.zero
        let xOffset = CGRectGetWidth(baseRect) * (scale - 1) / 2
        let yOffset = CGRectGetHeight(baseRect) * (scale - 1) / 2

        scaledPoint = CGPointMake(CGRectGetMinX(baseRect) - xOffset + point.x * scale, CGRectGetMinY(baseRect) - yOffset + point.y * scale)

        return scaledPoint
    }

    //MARK: Add New Bubble
    func showAddNewBubble(bubble: AIBubble, model: AIBuyerBubbleModel) {
        showTransitionStyleCrossDissolveView(AICustomSearchHomeViewController.initFromNib())
    }

    func showBuyerDetailWithBubble(bubble: AIBubble, model: AIBuyerBubbleModel) {

        if UIDevice.isIphone5 || UIDevice.isSimulatorIPhone5 {

            let viewsss = createBuyerDetailViewController(model)
            self.showDetailViewController(viewsss, sender: self)

        } else {

            // 获取原始中心点
            originalViewCenter = self.view.center

            // 获取放大后的半径 和 中心点
            let maxRadius = AITools.displaySizeFrom1080DesignSize(1384)
            let maxCenter = CGPointMake(CGRectGetWidth(self.view.frame) / 2, AITools.displaySizeFrom1080DesignSize(256))

            // 获取放大倍数
            curBubbleScale =  maxRadius / bubble.radius

            // 获取bubble在self.view的正确位置
            let realPoint: CGPoint  = bubble.superview!.convertPoint(bubble.center, toView: self.view)

            // 获取bubble放大以后再view中的坐标
            let scaledPoint = self.convertPointToScaledPoint(realPoint, scale: curBubbleScale!, baseRect: self.view.frame)

            // 计算中心点要移动的距离
            let xOffset = maxCenter.x - scaledPoint.x
            let yOffset = maxCenter.y - scaledPoint.y

            // 计算移动后的中心点
            curBubbleCenter = CGPointMake(self.view.center.x + xOffset, self.view.center.y + yOffset)

            // 动画过程中禁止响应用户的手势
            self.view.userInteractionEnabled = false

            // 处理detailViewController
            unowned let detailViewController = createBuyerDetailViewController(model)

            detailViewController.view.alpha = 0

            // Start CABasicAnimation.

            // Get the animation curve and duration
            let animationCurve: UIViewAnimationCurve = UIViewAnimationCurve.EaseIn
            let animationDuration: NSTimeInterval = 0.5
            // Animate view size synchronously with the appearance of the keyboard.
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(animationDuration)
            UIView.setAnimationCurve(animationCurve)
            UIView.setAnimationBeginsFromCurrentState(true)
            self.view.transform =  CGAffineTransformMakeScale(self.curBubbleScale!, self.curBubbleScale!)
            self.view.center = self.curBubbleCenter!
            UIView.commitAnimations()

            // self.presentViewController在真机iPhone5上会crash...
            self.presentViewController(detailViewController, animated: false) { () -> Void in
                // 开始动画
                SpringAnimation.springEaseIn(0.3, animations: {
                    detailViewController.view.alpha = 1
//                    detailViewController.view.transform = CGAffineTransformMakeScale(1, 1)
//                    detailViewController.view.center = self.originalViewCenter!
                    self.view.userInteractionEnabled = true
                })
            }

        }// end

    }

    func  createBuyerDetailViewController(model: AIBuyerBubbleModel) -> UIViewController {

        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController

        viewController.bubbleModel = model

        viewController.delegate = self

        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen


        return viewController
    }

    class func  createBuyerDetailViewController() -> AIBuyerDetailViewController {

        let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.UIBuyerStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AIBuyerDetailViewController) as! AIBuyerDetailViewController

        viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen


        return viewController
    }

    // MARK: - 构造顶部Bar

    func makeTopBar () {
        let barHeight: CGFloat = topBarHeight
        let buttonWidth: CGFloat = 80
        let imageSize: CGFloat = AITools.imageDisplaySizeFrom1080DesignSize((UIImage(named: "Buyer_Search")?.size)!).width

        topBar = UIView (frame: CGRectMake(0, 0, screenWidth, barHeight))
        self.view.addSubview(topBar!)

        let bgview = UIView(frame: topBar.bounds)
        topBar.addSubview(bgview)


        // calculate

        let top = (barHeight - imageSize) / 2

        // make search

        let searchButton = UIButton(type: .Custom)
        searchButton.frame = CGRectMake(0, 0, buttonWidth, barHeight)
        searchButton.setImage(UIImage(named: "Buyer_Search"), forState: UIControlState.Normal)
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(top, top, top, buttonWidth - imageSize - top)
        searchButton.addTarget(self, action: #selector(startSearch), forControlEvents: .TouchUpInside)
        topBar?.addSubview(searchButton)

        // make logo

        let logo = UIImage(named: "Buyer_Logo")
        let logoSie = AITools.imageDisplaySizeFrom1080DesignSize((logo?.size)!).width
        let logoButton = UIButton(type: .Custom)
        logoButton.frame = CGRectMake(0, 0, logoSie, logoSie)
        logoButton.setImage(logo, forState: UIControlState.Normal)
        logoButton.center = CGPointMake(screenWidth / 2, barHeight / 2 + 5)
        logoButton.addTarget(self, action: #selector(AIBuyerViewController.backToFirstPage), forControlEvents: .TouchUpInside)

        topBar?.addSubview(logoButton)


        // make more

        let moreButton = UIButton(type: .Custom)
        moreButton.frame = CGRectMake(screenWidth - 80, 0, buttonWidth, barHeight)
        moreButton.setImage(UIImage(named: "Buyer_More"), forState: UIControlState.Normal)
        moreButton.imageEdgeInsets = UIEdgeInsetsMake(top, buttonWidth - imageSize - top, top, top)
        moreButton.addTarget(self, action: #selector(AIBuyerViewController.moreButtonAction), forControlEvents: .TouchUpInside)
        topBar?.addSubview(moreButton)
    }

    func backToFirstPage () {
        AIOpeningView.instance().show()
    }

    func moreButtonAction() {
        self.makeBubbleView()
    }

    func startSearch() {
        showTransitionStyleCrossDissolveView(AICustomSearchHomeViewController.initFromNib())
    }

//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if  dataSource[indexPath.row].isExpanded {
//            return dataSource[indexPath.row].expandHeight!
//        } else {
//            return tableCellRowHeight
//        }
//    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("ExpandableTableViewCell") as! ExpandableTableViewCell

        if cell.topContentView == nil {
            let proposalModel = dataSource[indexPath.row].model!
            let folderCellView = AIFolderCellView.currentView()
            folderCellView.loadData(proposalModel)
            cell.setFoldedView(folderCellView)
        }
        
        if cell.expandedContentView == nil {
            cell.setBottomExpandedView(buildSuvServiceCard(dataSource[indexPath.row].model!))
        }
        
//        var cell: AITableFoldedCellHolder!
//
//        if let cacheCell: AITableFoldedCellHolder = tableViewCellCache[indexPath.row] as! AITableFoldedCellHolder? {
//            cell = cacheCell
//        } else {
//            cell = buildTableViewCell(indexPath)
//
//            tableViewCellCache[indexPath.row] = cell
//        }
//
//        let folderCellView = cell.foldedView
//        let expandedCellView = cell.expanedView
//
//        if dataSource[indexPath.row].isExpanded {
//            folderCellView?.hidden = true
//            expandedCellView?.hidden = false
//        } else {
//            folderCellView?.hidden = false
//            expandedCellView?.hidden = true
//        }
        
        cell.isExpanded = dataSource[indexPath.row].isExpanded

        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        //animate(cell)
    }

    // placeholder for things to come -- only fades in for now
    func animate(cell: UITableViewCell) {
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animateWithDuration(0.4) {
            view.layer.opacity = 1
        }
    }


    private func cellNeedRebuild(cell: AITableFoldedCellHolder) -> Bool {
        var needRebuild = false

        if let expanedView = cell.expanedView {
            needRebuild = expanedView.serviceOrderNumberIsChanged
        }

        return needRebuild
    }

    private func buildTableViewCell(indexPath: NSIndexPath) -> AITableFoldedCellHolder {
        let proposalModel = dataSource[indexPath.row].model!

        let cell = AITableFoldedCellHolder()
        cell.tag = indexPath.row
        let folderCellView = AIFolderCellView.currentView()
        folderCellView.loadData(proposalModel)
        folderCellView.frame = cell.contentView.bounds
        cell.foldedView = folderCellView
        cell.contentView.addSubview(folderCellView)

        let expandedCellView = buildExpandCellView(indexPath)
        cell.expanedView = expandedCellView
        cell.contentView.addSubview(expandedCellView)
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.layer.cornerRadius = 15

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if !dataSource[indexPath.row].isExpanded {
            rowSelectAction(indexPath)
        }
    }

    //处理表格点击事件
    func rowSelectAction(indexPath: NSIndexPath) {
        dataSource[indexPath.row].isExpanded = !dataSource[indexPath.row].isExpanded
        //如果有，做比较
        if let _ = lastSelectedIndexPath {
            //如果点击了不同的cell
            if lastSelectedIndexPath?.row != indexPath.row && dataSource[lastSelectedIndexPath!.row].isExpanded {
                dataSource[lastSelectedIndexPath!.row].isExpanded = false
            }
        }

        lastSelectedIndexPath = indexPath

        if let cacheCell: AITableFoldedCellHolder = tableViewCellCache[indexPath.row] as! AITableFoldedCellHolder? {
            if cellNeedRebuild(cacheCell) {
                tableViewCellCache[indexPath.row] = buildTableViewCell(indexPath)
            }
        }

        tableView.reloadData()

    }

    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            topBar.backgroundColor = UIColor(white: 0, alpha: 0.55)
        } else {
            topBar.backgroundColor = UIColor.clearColor()
        }
    }

    /*


    func handleScrollEventWithOffset(offset:CGFloat) {
        if let bView = bubbleViewContainer {
            let maxHeight = CGRectGetHeight(bView.frame) - topBarHeight

            if offset > maxHeight / 2 && offset <= maxHeight {
                tableView?.scrollRectToVisible(CGRectMake(0, maxHeight - AITools.displaySizeFrom1080DesignSize(96), screenWidth, CGRectGetHeight((tableView?.frame)!)), animated: true)
            } else if offset < maxHeight / 2 {
                tableView?.scrollRectToVisible(CGRectMake(0, 0, screenWidth, CGRectGetHeight((tableView?.frame)!)), animated: true)
            }
        }

    }


    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.handleScrollEventWithOffset(scrollView.contentOffset.y)
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.handleScrollEventWithOffset(scrollView.contentOffset.y)
    }

    */

    func parseListData(listData: ProposalOrderListModel?) {

        if let data = listData {
            tableViewCellCache.removeAllObjects()
            dataSource.removeAll()
            tableView.reloadData()
            for proposal in data.proposal_order_list {
                let wrapModel = self.proposalToProposalWrap(proposal as! ProposalOrderModel)

                dataSource.append(wrapModel)
            }

            // 添加占位区
            let offset = CGRectGetHeight(self.view.bounds) - self.topBarHeight - (CGFloat(self.dataSource.count)  *  self.tableCellRowHeight)
            if offset > 0 {
                let view = UIView(frame: CGRectMake(0, 0, self.screenWidth, offset))
                self.tableView.tableFooterView = view
            } else {
                self.tableView.tableFooterView = nil
            }

        }
    }


    func parseProposalData(proposalData: AIProposalPopListModel?) {


        if let data = proposalData {
            //TODO: 有泄漏
            if let pops = data.proposal_list {
                if pops.count > 0 {
                    self.dataSourcePop = pops as! [AIBuyerBubbleModel]
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.dataSourcePop = self.dataSourcePop
                    self.makeBubbleView()
                }
            }
        }

    }



    func proposalToProposalWrap(model: ProposalOrderModel) -> ProposalOrderModelWrap {
        var p = ProposalOrderModelWrap()
        p.model = model
        return p
    }

    func buildExpandCellView(indexPath: NSIndexPath) -> ProposalExpandedView {
        let proposalModel = dataSource[indexPath.row].model!
        let viewWidth = tableView.frame.size.width
        let servicesViewContainer = ProposalExpandedView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: PurchasedViewDimention.PROPOSAL_HEAD_HEIGHT))
        servicesViewContainer.proposalOrder = proposalModel
        servicesViewContainer.dimentionListener = self
        servicesViewContainer.delegate = self
        //新建展开view时纪录高度
        servicesViewContainer.tag = indexPath.row
        dataSource[indexPath.row].expandHeight = servicesViewContainer.getHeight()
        return servicesViewContainer
    }

    private func buildSuvServiceCard(model: ProposalOrderModel) -> SubServiceCardView {
        return SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView
    }

}


extension AIBuyerViewController : DimentionChangable, ProposalExpandedDelegate {
    func heightChanged(changedView: UIView, beforeHeight: CGFloat, afterHeight: CGFloat) {
        let expandView = changedView as! ProposalExpandedView
        let row = expandView.tag
        dataSource[row].expandHeight = afterHeight
        tableView.reloadData()
    }

    func headViewTapped(proposalView: ProposalExpandedView) {
        let indexPath = NSIndexPath(forRow: proposalView.tag, inSection: 0)
        rowSelectAction(indexPath)
    }
}

extension AIBuyerViewController : AIFoldedCellViewDelegate {
    func statusButtonDidClick(proposalModel: ProposalOrderModel) {
        let serviceExecVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIServiceExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICustomerServiceExecuteViewController)
        self.presentPopupViewController(serviceExecVC, animated: true)
    }
}

extension AIBuyerViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.dynamicType == UIPanGestureRecognizer.self {
            //Only the top most window in our stack will ever be allowed to have it's
            let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let velocity = panGestureRecognizer.velocityInView(popTableView)
            let location = panGestureRecognizer.locationInView(popTableView)
            return location.y <= panGestureMaxBeginYOffset && abs(velocity.y) >= panGestureThresholdYVelocity
            
        }
        return false
    }
  
}
