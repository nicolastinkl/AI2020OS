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
 
    var dataSource  = [ProposalOrderModelWrap]()
    var tableViewCellCache = NSMutableDictionary()    
    var lastSelectedIndexPath: NSIndexPath?
    var didRefresh: Bool?
    
    private let BUBBLE_VIEW_MARGIN = AITools.displaySizeFrom1080DesignSize(40)
    
    private let BUBBLE_VIEW_HEIGHT = AITools.displaySizeFrom1080DesignSize(1538)

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.showsVerticalScrollIndicator = true
        tableView.backgroundColor = UIColor.clearColor()
        return  tableView
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
        loadingData()
        
    }
    
    
    func loadingData() {
        view.showLoading()
        let bdk = BDKProposalService()
        // 列表数据
        weak var weakSelf = self

        bdk.getProposalList({ (responseData) -> Void in

            weakSelf!.didRefresh = true
            weakSelf!.parseListData(responseData)
            weakSelf!.tableView.reloadData()
            weakSelf!.view.hideLoading()
            }, fail: { (errType, errDes) -> Void in
                weakSelf!.view.hideLoading()
                weakSelf!.didRefresh = false
                weakSelf!.tableView.reloadData()
        })
        
    }
    
    // MARK: - 构造列表区域
    func makeTableView () {
        
        //改为使用虚化背景
        let blurEffect = UIBlurEffect(style: .Dark)
        // 使用你之前设置过的blurEffect来构建UIVibrancyEffect，UIVibrancyEffect是UIVisualEffect另一个子类。
        //let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        // 创建UIVisualEffectView来应用Vibrancy效果,这个过程恰巧跟生成模糊图一样。因为你使用的是自动布局所以在这里需要把自适应大小改为false
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
        
        
    }

    
    
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
//            let offset = CGRectGetHeight(self.view.bounds) - self.topBarHeight - (CGFloat(self.dataSource.count)  *  self.tableCellRowHeight)
//            if offset > 0 {
//                let view = UIView(frame: CGRectMake(0, 0, self.screenWidth, offset))
//                self.tableView.tableFooterView = view
//            } else {
//                self.tableView.tableFooterView = nil
//            }
            
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
        let card = SubServiceCardView.initFromNib("SubServiceCard") as! SubServiceCardView
        let imageContent = ImageCard(frame: CGRect.zero)
        imageContent.imgUrl = "http://171.221.254.231:3000/upload/shoppingcart/GNcdKBip4tYnW.png"
        card.setContentView(imageContent)
        
        return card
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
            folderCellView.loadData(dataSource[indexPath.row].model!)
            cell.mainView = folderCellView
        }
        
        if cell.getView("expanded") == nil {
            cell.addCandidateView("expanded", subView: buildSuvServiceCard(dataSource[indexPath.row].model!))
        }
        
        if dataSource[indexPath.row].isExpanded {
            cell.showView("expanded")
        } else {
            cell.showMainView()
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
        
        return cell
    }
    
    func statusButtonDidClick(proposalModel: ProposalOrderModel) {
        let serviceExecVC = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIServiceExecuteStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AICustomerServiceExecuteViewController)
        self.presentPopupViewController(serviceExecVC, animated: true)
    }
    
}



extension AIProposalTableViewController : DimentionChangable, ProposalExpandedDelegate {
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
