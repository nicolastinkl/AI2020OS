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
import AIAlertView

/// Proposal TableView 独立ViewController
class AIProposalTableViewController: UIViewController {
 
    var dataSource  = [ProposalOrderViewModel]()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
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
    }
    
    func refreshAfterNewOrder() {
        
        weak var ws = self
        // 取消延迟显示
        ws!.clearPropodalData()
        ws!.tableView.headerBeginRefreshing()
    }
    
    func loadingData() {
    
        let bdk = BDKProposalService()
        // 列表数据
        weak var weakSelf = self

        bdk.getProposalList({ (responseData) -> Void in
            if let weakSelf = weakSelf {
                weakSelf.didRefresh = true
                weakSelf.parseListData(responseData)
                weakSelf.tableView.headerEndRefreshing()
            }
            
            }, fail: { (errType, errDes) -> Void in
                
                weakSelf!.didRefresh = false
                weakSelf!.tableView.headerEndRefreshing()
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
        
        tableView.registerClass(SwitchedTableViewCell.self, forCellReuseIdentifier: "SwitchedTableViewCell")
        
        self.view.addSubview(tableView)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
        
        weak var weakSelf = self
        tableView.addHeaderRefreshEndCallback { () -> Void in
            if let weakSelf = weakSelf {
                weakSelf.tableView.reloadData()
            }
        }
        tableView.addHeaderWithCallback { () -> Void in
            if let weakSelf = weakSelf {
                weakSelf.loadingData()
            }
            
        }
    }
    
    func clearPropodalData() {
        
        dataSource.removeAll()
        tableView.reloadData()
    }

    
    
    func parseListData(listData: ProposalOrderListModel?) {
        
        if let _ = listData {
            if listData?.order_list.count > 0 {
                clearPropodalData()
                for proposal in listData!.order_list {
                    let model = proposalToVieModel(proposal as! ProposalOrderModel)

                    dataSource.append(model)
                }

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
        
        //mod by Shawn at 0822, reload之前先清除map对象，只能有一个实例
        AIMapView.sharedInstance.releaseView()
        tableView.reloadData()
        
    }
    
    func proposalToVieModel(model: ProposalOrderModel) -> ProposalOrderViewModel {
        let p = ProposalOrderViewModel(model: model)
        return p
    }
    
    private func buildSuvServiceCard(viewModel: ProposalOrderViewModel) -> ListSubServiceCardView {
        let list = ListSubServiceCardView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 50))
        if let _ = viewModel.model.service as? [ServiceOrderModel] {
            list.loadData(viewModel)
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
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        rowSelectAction(indexPath)
//        if !dataSource[indexPath.row].isExpanded {
//            rowSelectAction(indexPath)
//        }
    }


    
}

extension AIProposalTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchedTableViewCell") as! SwitchedTableViewCell
        // 构造收起时的cell
        if cell.mainView == nil {
            let folderCellView = AICustomerOrderFoldedView.currentView()
            folderCellView.delegate = self
            cell.mainView = folderCellView
        }
        
        (cell.mainView as! AICustomerOrderFoldedView).loadData(dataSource[indexPath.row])
        
        //改为点展开才构造展开的view, 每次构造cell都重新生成expandView
        if dataSource[indexPath.row].isExpanded {
            
            //if cell.getView("expanded") == nil {
                let serviceListCard = buildSuvServiceCard(dataSource[indexPath.row])
                serviceListCard.delegate = self
                cell.addCandidateView("expanded", subView: serviceListCard)
            //}
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
    
    
    
}

//MARK: -> subView所需delegate
extension AIProposalTableViewController: SubServiceCardViewDelegate, AIFoldedCellViewDelegate, AITimelineContentContainerViewDelegate {
    func statusButtonDidClick(proposalModel: ProposalOrderModel) {
        
        
        let serviceExecVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIServiceExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICustomerServiceExecuteViewController) as! AICustomerServiceExecuteViewController
        serviceExecVC.g_orderId = proposalModel.id
        serviceExecVC.g_orderItemId = proposalModel.item_id
        //弹出前先收起订单列表
        let parentVC = parentViewController as! AIBuyerViewController
        parentVC.finishPanDownwards(parentVC.popTableView, velocity: 0)
        parentVC.showTransitionStyleCrossDissolveView(serviceExecVC)
    }
    
    func containerImageDidLoad(viewModel viewModel: AITimelineViewModel, containterHeight: CGFloat) {
        
    }
    func confirmServiceButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        
        let requester = AICustomerServiceExecuteHandler.sharedInstance
        let procedureInstId = viewModel.itemId!
        requester.confirmOrderComplete(procedureInstId, action: "1", success: { (resultCode) in
            //AIAlertView().showSuccess("同意授权成功!", subTitle: "")
            //测试评论打开
            let commentVC = AISingleServiceCommnentViewController()
            commentVC.serviceID = viewModel.serviceInstanceId!
            let navi = UINavigationController(rootViewController: commentVC)
            navi.view.frame = self.view.bounds
            self.showTransitionStyleCrossDissolveView(navi)
        }) { (errType, errDes) in
            AIAlertView().showError("AICustomerServiceExecuteViewController.ConfirmError".localized, subTitle: "")
        }
        
    }
    func confirmOrderButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        let requester = AICustomerServiceExecuteHandler.sharedInstance
        let procedureInstId = viewModel.itemId!
        requester.confirmOrderComplete(procedureInstId, action: "1", success: { (resultCode) in
            AILog("confirmOrderComplete result: \(resultCode)")
            
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.UIAIASINFORecoverOrdersNotification, object: nil)
            //back to main view controller
            NSNotificationCenter.defaultCenter().postNotificationName(AIApplication.Notification.dissMissPresentViewController, object: nil)
            //打开支付页面
            let popupVC = AIPaymentViewController.initFromNib()
            popupVC.order_id = viewModel.orderId!
            //这个暂时从买家订单列表带过来
            popupVC.order_item_id = viewModel.orderItemId!
            let natigationController = UINavigationController(rootViewController: popupVC)
            self.showTransitionStyleCrossDissolveView(natigationController)
        }) { (errType, errDes) in
            AIAlertView().showSuccess("确认完成失败!", subTitle: "")
        }
        
    }
    func refuseButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        AIAlertView().showInfo("忽略授权请求!", subTitle: "")
    }
    func acceptButtonDidClick(viewModel viewModel: AITimelineViewModel) {
        let requester = AICustomerServiceExecuteHandler.sharedInstance
        let procedureInstId = viewModel.itemId!
        requester.customerAuthorize(procedureInstId, action: "1", success: { (resultCode) in
            AILog("acceptAuthorize result: \(resultCode)")
            AIAlertView().showSuccess("同意授权成功!", subTitle: "")
        }) { (errType, errDes) in
            AIAlertView().showSuccess("同意授权失败!", subTitle: "")
        }
        
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
