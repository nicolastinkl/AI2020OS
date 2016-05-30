//
//  AIServiceTagFilterViewController.swift
//  AI2020OS
//
//  Created by admin on 15/6/9.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIServiceTagFilterViewController: UIViewController {
    
    let SectionHeaderViewIdentifier = "SectionHeaderViewIdentifier"
    var sectionInfoArray:NSMutableArray!
    var pinchedIndexPath:NSIndexPath!
    var opensectionindex:Int!
    var initialPinchHeight:CGFloat!
    
    //筛选值的delegate变量，初始化这个controller的时候要传进来
    var delegate:AIFilterViewDelegate?
    var playe: [Play]?
    
    @IBOutlet weak var tableView: UITableView!
    var sectionHeaderView:SectionHeaderView!
    
    //当缩放手势同时改变了所有单元格高度时使用uniformRowHeight
    var uniformRowHeight: Int!
    
    let DefaultRowHeight = 48
    let HeaderHeight = 48
    let QuoteCellIdentifier = "tagFilterTableCell"
    
    private var tags: [String]?
    private var manager: AIFavorServicesManager?
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        // 设置Header的高度
        self.tableView.sectionHeaderHeight = CGFloat(HeaderHeight)
        
        // 分节信息数组在viewWillUnload方法中将被销毁，因此在这里设置Header的默认高度是可行的。如果您想要保留分节信息等内容，可以在指定初始化器当中设置初始值。
        
        self.uniformRowHeight = DefaultRowHeight
        self.opensectionindex = NSNotFound
        
        let sectionHeaderNib: UINib = UINib(nibName: "SectionHeaderView", bundle: nil)
        
        self.tableView.registerNib(sectionHeaderNib, forHeaderFooterViewReuseIdentifier: SectionHeaderViewIdentifier)
        
        manager = AIMockFavorServicesManager()
        
        manager?.getServiceTags(loadTagData)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    private func loadTagData(result: (model: [String], err: Error?)) {
        
        if result.err == nil {
            tags = result.model
        }
        
        if tags != nil {
            var playeCount = 2
            
            if playe == nil {
                playe = [Play]()
            }
            
            for var i = 0; i < playeCount; ++i {
                var play = Play()
                switch i {
                case 0:
                    play.name = "全部"
                case 1:
                    play.name = "按标签筛选"
                    var quotations = NSMutableArray(capacity: tags!.count)
                    
                    for tag in tags! {
                        var dic = NSDictionary(object: tag, forKey: "tagName")
                        quotations.addObject(dic)
                    }
                    
                    play.quotations = quotations
                    
                default:
                    continue
                }
                
                playe!.append(play)
            }
            
            var infoArray = NSMutableArray()
            
            for play in playe! {
                var dic = (play as Play).quotations
                var sectionInfo = SectionInfo()
                sectionInfo.play = play as Play
                sectionInfo.open = false
                
                var defaultRowHeight = DefaultRowHeight
                var countOfQuotations = sectionInfo.play.quotations.count
                for (var i = 0; i < countOfQuotations; i++) {
                    sectionInfo.insertObject(defaultRowHeight, inRowHeightsAtIndex: i)
                }
                
                infoArray.addObject(sectionInfo)
            }
            
            self.sectionInfoArray  = infoArray

            
            tableView.reloadData()
        }

    }
}

extension AIServiceTagFilterViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        if sectionInfoArray == nil {
            return 0
        } else {
            return sectionInfoArray.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 这个方法返回对应的section有多少个元素，也就是多少行
        var sectionInfo: SectionInfo = self.sectionInfoArray[section] as SectionInfo
        var numStoriesInSection = sectionInfo.play.quotations.count
        var sectionOpen = sectionInfo.open!
        
        return sectionOpen ? numStoriesInSection : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(QuoteCellIdentifier) as UITableViewCell
        
        var play:Play = (self.sectionInfoArray[indexPath.section] as SectionInfo).play
        let quotation = play.quotations[indexPath.row] as NSDictionary
        cell.textLabel.text = quotation["tagName"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 返回指定的 section header 的view，如果没有，这个函数可以不返回view
        var sectionHeaderView: SectionHeaderView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier(SectionHeaderViewIdentifier) as SectionHeaderView
        var sectionInfo: SectionInfo = self.sectionInfoArray[section] as SectionInfo
        sectionInfo.headerView = sectionHeaderView
        
        sectionHeaderView.titleLabel.text = sectionInfo.play.name
        sectionHeaderView.section = section
        sectionHeaderView.delegate = self
        
        return sectionHeaderView
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 这个方法返回指定的 row 的高度
        var sectionInfo: SectionInfo = self.sectionInfoArray[indexPath.section] as SectionInfo
        
        return CGFloat(sectionInfo.objectInRowHeightsAtIndex(indexPath.row) as NSNumber)
        //又或者，返回单元格的行高
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var play:Play = (self.sectionInfoArray[indexPath.section] as SectionInfo).play
        let quotation = play.quotations[indexPath.row] as NSDictionary
        var userInfo:Dictionary<String,String!> = ["tagName":quotation["tagName"] as? String,"filterType":play.filterType]
        //发送消息通知
        
        NSNotificationCenter.defaultCenter().postNotificationName("filterFlagChoose", object: nil, userInfo:  userInfo)
        
        self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion({ (Void) -> Void in
            self.delegate?.passChoosedValue(userInfo["tagName"]!)
            return
        })
    }
}

extension AIServiceTagFilterViewController: SectionHeaderViewDelegate {
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionOpened: Int) {
        
        var sectionInfo: SectionInfo = self.sectionInfoArray[sectionOpened] as SectionInfo
        
        sectionInfo.open = true
        
        //创建一个包含单元格索引路径的数组来实现插入单元格的操作：这些路径对应当前节的每个单元格
        
        var countOfRowsToInsert = sectionInfo.play.quotations.count
        var indexPathsToInsert = NSMutableArray()
        
        for (var i = 0; i < countOfRowsToInsert; i++) {
            indexPathsToInsert.addObject(NSIndexPath(forRow: i, inSection: sectionOpened))
        }
        
        // 创建一个包含单元格索引路径的数组来实现删除单元格的操作：这些路径对应之前打开的节的单元格
        
        var indexPathsToDelete = NSMutableArray()
        
        var previousOpenSectionIndex = self.opensectionindex
        if previousOpenSectionIndex != NSNotFound {
            
            var previousOpenSection: SectionInfo = self.sectionInfoArray[previousOpenSectionIndex] as SectionInfo
            previousOpenSection.open = false
            previousOpenSection.headerView.toggleOpenWithUserAction(false)
            var countOfRowsToDelete = previousOpenSection.play.quotations.count
            for (var i = 0; i < countOfRowsToDelete; i++) {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: previousOpenSectionIndex))
            }
        }
        
        // 设计动画，以便让表格的打开和关闭拥有一个流畅（很屌）的效果
        var insertAnimation: UITableViewRowAnimation
        var deleteAnimation: UITableViewRowAnimation
        if previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex {
            insertAnimation = UITableViewRowAnimation.Top
            deleteAnimation = UITableViewRowAnimation.Bottom
        }else{
            insertAnimation = UITableViewRowAnimation.Bottom
            deleteAnimation = UITableViewRowAnimation.Top
        }
        
        // 应用单元格的更新
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths(indexPathsToDelete as [AnyObject], withRowAnimation: deleteAnimation)
        self.tableView.insertRowsAtIndexPaths(indexPathsToInsert as [AnyObject], withRowAnimation: insertAnimation)
        
        self.opensectionindex = sectionOpened
        
        self.tableView.endUpdates()
        
        if sectionOpened == 0 {
            self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion({ (Void) -> Void in
                self.delegate?.passChoosedValue("")
                return
            })
        }
        
    }
    
    func sectionHeaderView(sectionHeaderView: SectionHeaderView, sectionClosed: Int) {
        
        // 在表格关闭的时候，创建一个包含单元格索引路径的数组，接下来从表格中删除这些行
        var sectionInfo: SectionInfo = self.sectionInfoArray[sectionClosed] as SectionInfo
        
        sectionInfo.open = false
        var countOfRowsToDelete = self.tableView.numberOfRowsInSection(sectionClosed)
        
        if countOfRowsToDelete > 0 {
            var indexPathsToDelete = NSMutableArray()
            for (var i = 0; i < countOfRowsToDelete; i++) {
                indexPathsToDelete.addObject(NSIndexPath(forRow: i, inSection: sectionClosed))
            }
            self.tableView.deleteRowsAtIndexPaths(indexPathsToDelete as [AnyObject], withRowAnimation: UITableViewRowAnimation.Top)
        }
        
        self.opensectionindex = NSNotFound
        
        if sectionClosed == 0 {
            self.findHamburguerViewController()?.hideMenuViewControllerWithCompletion({ (Void) -> Void in
                self.delegate?.passChoosedValue("")
                return
            })
        }
    }
}

extension AIServiceTagFilterViewController : DLHamburguerViewControllerDelegate {
    @objc func hamburguerViewController(hamburguerViewController: DLHamburguerViewController, willHideMenuViewController menuViewController: UIViewController) {
        println("willHideMenuViewController")
    }
}


