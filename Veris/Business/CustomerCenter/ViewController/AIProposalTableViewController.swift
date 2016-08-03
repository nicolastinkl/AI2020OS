//
//  AIProposalTableViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// Proposal TableView 独立ViewController
class AIProposalTableViewController: UIViewController {
 
    var dataSource  = [ProposalOrderViewModel]()
    var tableViewCellCache = NSMutableDictionary()    
    var lastSelectedIndexPath: NSIndexPath?
    var didRefresh: Bool?
    
    private let BUBBLE_VIEW_MARGIN = AITools.displaySizeFrom1080DesignSize(40)
    
    private let BUBBLE_VIEW_HEIGHT = AITools.displaySizeFrom1080DesignSize(1538)

    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = UIColor.clearColor()
        return  tableView
    }()
    
    
    let kCellHeight: CGFloat = 120.0
    let kItemSpace: CGFloat = -30.0
    let kAIProposalCellIdentifierss = "kAIProposalCellIdentifier"
        
    private lazy var collectionView: UICollectionView = {
        let coll = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: StickyCollectionViewFlowLayout())
        coll.delegate = self
        coll.dataSource = self
        coll.backgroundColor = UIColor.clearColor()
        coll.showsHorizontalScrollIndicator = false
        return coll
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         Structure UITableView
         */
        makeTableView() 
        
        /**
         Loading Data From Networking
         */
        if AILoginUtil.isLogin() {
            self.tableView.headerBeginRefreshing()
        }
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AIBuyerViewController.refreshAfterNewOrder), name: AIApplication.Notification.UIAIASINFOLoginNotification, object: nil)
    }
    
    func refreshAfterNewOrder() {
        
        weak var ws = self
        Async.main(after: 0.2) { () -> Void in
            ws!.tableView.headerBeginRefreshing()
        }
    }
    
    func loadingData() {
    
        let bdk = BDKProposalService()
        // 列表数据
        weak var weakSelf = self

        bdk.getProposalList({ (responseData) -> Void in
            if let weakSelf = weakSelf {
                weakSelf.didRefresh = true
                weakSelf.parseListData(responseData)
                weakSelf.tableView.reloadData()
                weakSelf.tableView.headerEndRefreshing()
            }
            
            }, fail: { (errType, errDes) -> Void in
                
                weakSelf!.didRefresh = false
                weakSelf!.tableView.reloadData()
        })
    }
    
    // MARK: - 构造列表区域
    func makeTableView() {
        
        //改为使用虚化背景
        let blurEffect = UIBlurEffect(style: .Dark)
        let vibrancyView = UIVisualEffectView(effect: blurEffect)
        vibrancyView.frame = self.view.frame
        self.view.addSubview(vibrancyView)
        
        let y: CGFloat = 44
        let label: UPLabel = AIViews.normalLabelWithFrame(CGRectMake(BUBBLE_VIEW_MARGIN, y, screenWidth - 2 * BUBBLE_VIEW_MARGIN, 20), text: "AIBuyerViewController.progress".localized, fontSize: 20, color: UIColor.whiteColor())
        view.addSubview(label)
        label.textAlignment = .Right
        label.verticalAlignment = UPVerticalAlignmentMiddle
        label.text = "AIBuyerViewController.progress".localized
        label.font = AITools.myriadRegularWithSize(20)
        
        vibrancyView.setTop(y + 30)
        tableView.setTop(y + 30)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        
        tableView.registerClass(AITableFoldedCellHolder.self, forCellReuseIdentifier: AIApplication.MainStoryboard.CellIdentifiers.AITableFoldedCellHolder)
        
        tableView.registerClass(SwitchedTableViewCell.self, forCellReuseIdentifier: "SwitchedTableViewCell")
        
        self.view.addSubview(tableView)
        
        
        weak var weakSelf = self
        tableView.addHeaderRefreshEndCallback { () -> Void in
            if let weakSelf = weakSelf {
                weakSelf.tableView.reloadData()
                weakSelf.collectionView.reloadData()
            }
        }
        tableView.addHeaderWithCallback { () -> Void in
            if let weakSelf = weakSelf {
                weakSelf.clearPropodalData()
                weakSelf.loadingData()
            }
            
        }
    }
    
    func clearPropodalData() {
        
        dataSource.removeAll()
        tableView.reloadData()
    }

    
    
    func parseListData(listData: ProposalOrderListModel?) {
        
        if let data = listData {
            tableViewCellCache.removeAllObjects()
            dataSource.removeAll()
            tableView.reloadData()
            for proposal in data.order_list {
                let model = proposalToVieModel(proposal as! ProposalOrderModel)
                
                dataSource.append(model)
            }
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
    
    
    
    func proposalToVieModel(model: ProposalOrderModel) -> ProposalOrderViewModel {
        let p = ProposalOrderViewModel(model: model)
        return p
    }
    
    func buildExpandCellView(indexPath: NSIndexPath) -> ProposalExpandedView {
        let proposalModel = dataSource[indexPath.row].model!
        let viewWidth = tableView.frame.size.width
        let servicesViewContainer = ProposalExpandedView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: PurchasedViewDimention.PROPOSAL_HEAD_HEIGHT))
        servicesViewContainer.proposalOrder = proposalModel
        servicesViewContainer.dimentionListener = self
        servicesViewContainer.delegate = self
        
        servicesViewContainer.tag = indexPath.row
        return servicesViewContainer
    }
    
    private func buildSuvServiceCard(model: ProposalOrderModel) -> ListSubServiceCardView {
        let list = ListSubServiceCardView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 50))
        if let _ = model.service as? [ServiceOrderModel] {
            list.loadData(model)
        }
        
        return list
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
        
        rowSelectAction(indexPath)
//        if !dataSource[indexPath.row].isExpanded {
//            rowSelectAction(indexPath)
//        }
    }


    
}

extension AIProposalTableViewController: UITableViewDelegate, UITableViewDataSource, AIFoldedCellViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchedTableViewCell") as! SwitchedTableViewCell
        if cell.mainView == nil {
            let folderCellView = AICustomerOrderFoldedView.currentView()
            folderCellView.delegate = self
            folderCellView.loadData(dataSource[indexPath.row].model)
            cell.mainView = folderCellView
        }
        
        if cell.getView("expanded") == nil {
            cell.addCandidateView("expanded", subView: buildSuvServiceCard(dataSource[indexPath.row].model))
        }
        
        if dataSource[indexPath.row].isExpanded {
            cell.showView("expanded")
            cell.isBottomRoundCorner = true
            cell.isTopRoundCorner = true
        } else {
            cell.showMainView()
            cell.isBottomRoundCorner = false
            cell.isTopRoundCorner = true
        }
        
        if indexPath.row == dataSource.count - 1 {
            cell.isBottomRoundCorner = true
        }
        
        cell.selectionStyle = .None
      
        return cell
    }
    
    func statusButtonDidClick(proposalModel: ProposalOrderModel) {

        
        let serviceExecVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIServiceExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICustomerServiceExecuteViewController)
       
//        if let navigationController = self.navigationController {
//            navigationController.pushViewController(serviceExecVC, animated: true)
//        } else {

            //弹出前先收起订单列表
            let parentVC = self.parentViewController as! AIBuyerViewController
            parentVC.finishPanDownwards(parentVC.popTableView, velocity: 0)
            let TopMargin: CGFloat = 15.3
            serviceExecVC.view.frame.size.height = UIScreen.mainScreen().bounds.height - TopMargin
            self.presentPopupViewController(serviceExecVC, animated: true)
        //}
        
    }
    
}



extension AIProposalTableViewController : DimentionChangable, ProposalExpandedDelegate {
    func heightChanged(changedView: UIView, beforeHeight: CGFloat, afterHeight: CGFloat) {
        tableView.reloadData()
    }
    
    func headViewTapped(proposalView: ProposalExpandedView) {
        let indexPath = NSIndexPath(forRow: proposalView.tag, inSection: 0)
        rowSelectAction(indexPath)
    }
}

extension AIProposalTableViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.dynamicType == UICollectionView.self {
            if scrollView.contentOffset.y < 0 {
                //Throw UIGesture To SuperView.
//                superVC?.didRecognizePanGesture(scrollView.panGestureRecognizer)
                
            } else {
//                self.collectionView.scrollEnabled = true
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kAIProposalCellIdentifierss, forIndexPath: indexPath) as! AIProposalCollCell
        
        if cell.backingView.subviews.count == 1 {
            let folderCellView = AICustomerOrderFoldedView.currentView()
            folderCellView.delegate = self
            folderCellView.loadData(dataSource[indexPath.row].model!)
            cell.backingView.addSubview(folderCellView)
            folderCellView.pinToTopEdgeOfSuperview()
            folderCellView.pinToLeftEdgeOfSuperview()
            folderCellView.pinToRightEdgeOfSuperview()
            folderCellView.sizeToHeight(97)
        }
    
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(view.bounds), kCellHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: NSInteger) -> CGFloat {
        return kItemSpace
    }

}


class AIProposalCollCell: UICollectionViewCell {
    
    var backingView: UIView = UIView()
    
    var color: UIColor? {
        didSet {
            backingView.backgroundColor = color
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Settings Shadow.
        
        if let _ = self.contentView.viewWithTag(2) {
        } else {
            let imageview = UIImageView(image: UIImage(named: "bllw_shadow"))
            self.contentView.addSubview(imageview)
            imageview.tag == 2
            imageview.pinToTopEdgeOfSuperview()
            imageview.pinToLeftEdgeOfSuperview()
            imageview.pinToRightEdgeOfSuperview()
            imageview.sizeToHeight(17)
            imageview.alpha = 0.6
        }
        
        // Settings backingView.
        if let _ = self.contentView.viewWithTag(1) {
        } else {
            
            backingView.tag = 1
            self.contentView.addSubview(backingView)
            backingView.pinToBottomEdgeOfSuperview()
            backingView.pinToLeftEdgeOfSuperview()
            backingView.pinToRightEdgeOfSuperview()
            backingView.pinToTopEdgeOfSuperview(offset: 10, priority: UILayoutPriorityDefaultHigh)
            backingView.layer.cornerRadius = 10
            backingView.layer.masksToBounds = true
            // Add EffectView to BackingView.
            if backingView.subviews.count == 0 {
                let blurEffect = UIBlurEffect(style: .Dark)
                let vibrancyView = UIVisualEffectView(effect: blurEffect)
                backingView.addSubview(vibrancyView)
                vibrancyView.pinToEdgesOfSuperview()
                
            }
            
        }        
        
    }
}
