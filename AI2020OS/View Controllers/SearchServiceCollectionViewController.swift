//
//  SearchServiceViewControllerCollectionViewController.swift
//  AI2020OS
//
//  Created by admin on 15/5/25.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit



class SearchServiceViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var historyRecorder: SearchRecorder?
    private var searchEngine: SearchEngine?
    
    private let SECTION_HOT_SERVICES = 0
    private let SECTION_HISTORY = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        var engine = HttpSearchEngine()
        historyRecorder = engine
        searchEngine = engine

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
     //   self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemNum = 0
        
        switch section {
        case SECTION_HOT_SERVICES:
            var (list, error) = searchEngine!.queryHotSearchedServices()
            itemNum = list.count
        case SECTION_HISTORY:
            itemNum = historyRecorder!.getSearchHistoryItems().count
        default:
            itemNum = 0
        }
        
        if itemNum > 10 {
            itemNum = 10
        }
        
        return itemNum
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CONTENT", forIndexPath: indexPath) as SearchTagCell
    
        cell.maxWidth = collectionView.bounds.size.width
        
        let records = historyRecorder!.getSearchHistoryItems()
        
        let (list, error) = searchEngine!.queryHotSearchedServices()
        
        var tagName = ""
        
        if indexPath.section == SECTION_HOT_SERVICES {
            tagName = list[indexPath.item].catalog_name!
        } else if indexPath.section == SECTION_HISTORY {
            tagName = records[indexPath.item].name
        }
        
        cell.text = tagName
    
        return cell
    }
  
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        if (kind == UICollectionElementKindSectionHeader) {
            let cell =
            collectionView.dequeueReusableSupplementaryViewOfKind(
                kind, withReuseIdentifier: "HEADER",
                forIndexPath: indexPath) as SearchHeaderCell
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
            let (list, error) = searchEngine!.queryHotSearchedServices()

            var tagName = ""
            
            if indexPath.section == SECTION_HOT_SERVICES {
                tagName = list[indexPath.item].catalog_name!
            } else if indexPath.section == SECTION_HISTORY {
                tagName = records[indexPath.item].name
            }
            
        let size = SearchTagCell.sizeForContentString(tagName,
                forMaxWidth: collectionView.bounds.size.width / 2)
        return size
    }
    
    private func initCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout
        let flow = layout as UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        collectionView.registerClass(SearchTagCell.self,
            forCellWithReuseIdentifier: "CONTENT")
        collectionView.registerClass(SearchHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: "HEADER")
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
//        return false
//    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let records = historyRecorder!.getSearchHistoryItems()
        let (list, error) = searchEngine!.queryHotSearchedServices()
        
        if indexPath.section == SECTION_HOT_SERVICES {
            println(list[indexPath.item].catalog_name)
       //     tagName = services[indexPath.item].name
        } else if indexPath.section == SECTION_HISTORY {
            println(records[indexPath.item].name)
     //       tagName = records[indexPath.item].name
        }
    }
    
    @IBAction func showAllServices(sender: UIButton) {
        println("showAllServices")
    }

    @IBAction func myFavorites(sender: AnyObject) {
        println("myFavorites")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchEngine!.queryHotSearchedServices()
        return true
    }

}
