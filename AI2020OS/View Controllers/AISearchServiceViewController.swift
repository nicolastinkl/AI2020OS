//
//  AISearchServiceViewControllerCollectionViewController.swift
//  AI2020OS
//
//  Created by liliang on 15/5/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit 

class AISearchServiceViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var historyRecorder: SearchRecorder?
    private var searchEngine: SearchEngine?
    
    private let SECTION_HOT_SERVICES = 0
    private let SECTION_HISTORY = 1
    
    private var catalogList: [AIServiceCatalogModel]?
    private var recordList: [SearchHistoryRecord]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        var engine = HttpSearchEngine()
        historyRecorder = MockSearchEngine()
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
        let record: SearchHistoryRecord = SearchHistoryRecord(searchName: textField.text)
        historyRecorder?.recordSearch(record)
        recordList?.append(record)
        collectionView.reloadData()
        //     searchEngine!.queryHotSearchedServices()
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
        println("showAllServices")
        searchEngine?.queryHotSearchedServices(self.loadTableViewData)
    }

    @IBAction func myFavorites(sender: AnyObject) {
        
    }
    
    private func queryHotSuccess(responseData: [AIServiceCatalogModel]) {
        collectionView.reloadData()
    }
    
    private func queryHotFail(errType: AINetError, errDes: String) {
        
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
            if catalogList != nil {
                itemNum = catalogList!.count
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
            if catalogList != nil {
                tagName = catalogList![indexPath.item].catalog_name!
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
            let cell =
            collectionView.dequeueReusableSupplementaryViewOfKind(
                kind, withReuseIdentifier: "HEADER",
                forIndexPath: indexPath) as AISearchHeaderCell
            cell.maxWidth = collectionView.bounds.size.width
            
            if indexPath.section == SECTION_HOT_SERVICES {
                cell.text = "热门服务"
            } else if indexPath.section == SECTION_HISTORY {
                cell.text = "搜索历史"
            }
            
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
                if catalogList != nil {
                    tagName = catalogList![indexPath.item].catalog_name!
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
            //     tagName = services[indexPath.item].name
        } else if indexPath.section == SECTION_HISTORY {
            //       tagName = records[indexPath.item].name
        }
    }
    
}
