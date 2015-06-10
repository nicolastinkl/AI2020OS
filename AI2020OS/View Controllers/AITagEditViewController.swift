
//
//  AITagEditViewController.swift
//  AI2020OS
//
//  Created by 刘先 on 15/6/10.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

class AITagEditViewController : UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // MARK: swift source
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: variables
    
    var tagArray=[Tag(isSelected:false,isLocked:false,textContent:"音乐"),Tag(isSelected:false,isLocked:false,textContent:"视频"),Tag(isSelected:false,isLocked:false,textContent:"新闻"),Tag(isSelected:false,isLocked:false,textContent:"游记"),Tag(isSelected:false,isLocked:false,textContent:"出国游记"),Tag(isSelected:false,isLocked:false,textContent:"买电器评价"),Tag(isSelected:false,isLocked:false,textContent:"你是猪"),Tag(isSelected:false,isLocked:false,textContent:"oh my baby")]
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: extension UITableView
    //定义展示的UICollectionViewCell的个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagArray.count
    }
    //定义展示的section的个数
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //定义uicollectionview展示的内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellId = "tagCollectionCell"
        var cell:RRTagCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as RRTagCollectionViewCell
        
        var tag = tagArray[indexPath.row]
        cell.initContent(tag)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(60, 30)
    }
    
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell: RRTagCollectionViewCell? = collectionView.cellForItemAtIndexPath(indexPath) as? RRTagCollectionViewCell
        
            var currentTag = tagArray[indexPath.row]
            
            if tagArray[indexPath.row].isSelected == false {
                tagArray[indexPath.row].isSelected = true
                selectedCell?.animateSelection(tagArray[indexPath.row].isSelected)
                //totalTagsSelected = 1
            }
            else {
                tagArray[indexPath.row].isSelected = false
                selectedCell?.animateSelection(tagArray[indexPath.row].isSelected)
                //totalTagsSelected = -1
            }
    }
}