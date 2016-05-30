//
//  AISearchServiceViewControllerCollectionViewController.swift
//  AI2020OS
//
//  Created by liliang on 15/5/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import SCLAlertView

class AISearchServiceViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var historyRecorder: SearchRecorder?
    private var searchEngine: SearchEngine?
    
    private let SECTION_HOT_SERVICES = 0
    private let SECTION_HISTORY = 1
    
    private var searchHotList: [AISearchResultItem]?
    private var recordList: [SearchHistoryRecord]?
    
    private var preSearchText:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        var engine = HttpSearchEngine()
        historyRecorder = engine
        searchEngine = engine
        
        
        AIApplication.hideMessageUnreadView()
        
        recordList = historyRecorder?.getSearchHistoryItems()
    }
    
    
    func loadTableViewData(result: (model: [AICatalogItemModel], err: Error?)) {
        
        if result.err == nil {
            collectionView.reloadData()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        view.showProgressViewLoading()

        searchEngine?.queryHotSearchedServices(queryHotSuccess, fail: queryHotFail)
//        Async.background { () -> Void in
//            self.searchEngine?.queryHotSearchedServices(self.loadTableViewData)
//            return
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Call back
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        search()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    private func initCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout
        let flow = layout as UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        collectionView.registerClass(AISearchTagCell.self,
            forCellWithReuseIdentifier: "CONTENT")
        collectionView.registerClass(AISearchHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: "HEADER")
        
        
    }
    
    @IBAction func showAllServices(sender: UIButton) {
        //searchEngine?.queryHotSearchedServices(self.loadTableViewData)
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchButtonAction(sender: AnyObject) {
        searchTextField.resignFirstResponder()
        search()
    }
    
    @IBAction func myFavorites(sender: AnyObject) {
        
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        searchTextField.resignFirstResponder()
    }
    
    @IBAction func cancelSearch(sender: AnyObject) {
        searchTextField.resignFirstResponder()
    }
    
    private func queryHotSuccess(responseData: [AISearchResultItem]) {
        self.searchHotList = responseData
        collectionView.reloadData()
        view.hideProgressViewLoading()
    }
    
    private func queryHotFail(errType: AINetError, errDes: String) {
        view.hideProgressViewLoading()
        UIAlertView(title: "提示", message: "热门服务查询失败", delegate: nil, cancelButtonTitle: "关闭").show()
    }
    
    private func search() {
        let text = searchTextField.text.trim()
        
        if text.isEmpty {
            UIAlertView(title: "提示", message: "搜索内容不能为空", delegate: nil, cancelButtonTitle: "关闭").show()
        } else {
            searchByText(text)
        }
    }
    
    private func searchByText(text: String) {
        let record: SearchHistoryRecord = SearchHistoryRecord(searchName: text)
        historyRecorder?.recordSearch(record)
        recordList?.append(record)
        collectionView.reloadData()
        
        view.showProgressViewLoading()
        searchEngine?.searchServicesAndCatalogs(text, pageNum: 1, pageSize: 10, successRes: queryServicesAndCatalogsSuccess, fail: queryHotFail)
    }
    
    private func queryServicesAndCatalogsSuccess(responseData: AISearchServicesAndCatalogsResultModel) {
        view.hideProgressViewLoading()
        
        if responseData.catalogArray != nil || responseData.serviceArray != nil {
            let viewController = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AISearchStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AISimpleServiceTableViewController) as AISimpleServiceTableViewController
            viewController.data = responseData
            viewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            viewController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            self.showViewController(viewController, sender: self)
            //presentViewController(viewController, animated: true, completion: nil)
        } else {
            UIAlertView(title: "提示", message: "没有相关数据", delegate: nil, cancelButtonTitle: "关闭").show()
        }
    }
    
    func retryNetworkingAction(){
        
        searchByText(preSearchText)
    }
    
    func deleteHistory() {
        recordList?.removeAll(keepCapacity: false)
        historyRecorder?.clearHistory()
        collectionView.reloadData()
    }

}

extension AISearchServiceViewController: UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemNum = 0
        
        switch section {
        case SECTION_HOT_SERVICES:
            if searchHotList != nil {
                itemNum = searchHotList!.count
            }
        case SECTION_HISTORY:
            if recordList != nil {
                itemNum = recordList!.count
            }
        default:
            itemNum = 0
        }
        
        if itemNum > 10 {
            itemNum = 10
        }
        
        return itemNum
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CONTENT", forIndexPath: indexPath) as AISearchTagCell
        
        cell.maxWidth = collectionView.bounds.size.width
        
        
        var tagName = ""
        
        if indexPath.section == SECTION_HOT_SERVICES {
            if searchHotList != nil {
                tagName = searchHotList![indexPath.item].name!
            }
        } else if indexPath.section == SECTION_HISTORY {
            if recordList != nil {
                tagName = recordList![indexPath.item].name
            }
        }
        
        cell.text = tagName
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            
            let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Head", forIndexPath: indexPath) as AIHistorySearchHeaderCell
            
            if indexPath.section == SECTION_HOT_SERVICES {
                cell.title.text = "热门服务"
                cell.deleteButton.hidden = true
            } else if indexPath.section == SECTION_HISTORY {
                cell.title.text = "搜索历史"
                cell.deleteButton.addTarget(self, action: "deleteHistory", forControlEvents: UIControlEvents.TouchUpInside)
                cell.deleteButton.hidden = false
            }
            cell.backgroundColor = UIColor(rgba: "#f2f2f1")
            
            return cell
            
        }
        abort()
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            indexPath.row
            let records = historyRecorder!.getSearchHistoryItems()
            
            var tagName = ""
            
            if indexPath.section == SECTION_HOT_SERVICES {
                if searchHotList != nil {
                    tagName = searchHotList![indexPath.item].name!
                }
                
            } else if indexPath.section == SECTION_HISTORY {
                tagName = records[indexPath.item].name
            }
            
            let size = AISearchTagCell.sizeForContentString(tagName,
                forMaxWidth: collectionView.bounds.size.width / 2)
            return size
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let records = historyRecorder!.getSearchHistoryItems()
        
        if indexPath.section == SECTION_HOT_SERVICES {
            preSearchText = searchHotList![indexPath.item].name
            searchByText(searchHotList![indexPath.item].name)
        } else if indexPath.section == SECTION_HISTORY {
            preSearchText = recordList![indexPath.item].name
            searchByText(recordList![indexPath.item].name)
        }
    }
    
}
