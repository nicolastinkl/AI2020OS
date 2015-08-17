//
//  AISingleEvaluationViewCellTableViewCell.swift
//  AI2020OS
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISingleCommentView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        
        collectionView.registerClass(AICommentTagViewCell.self,
            forCellWithReuseIdentifier: "CONTENT")

  //      NSBundle.mainBundle().loadNibNamed("AISingleEvaluationView", owner: self, options: nil)
        
  //      addSubview(contentView)

    }
    
    class func instance(owner: AnyObject!) -> AISingleCommentView {
        return NSBundle.mainBundle().loadNibNamed("AISingleCommentView", owner: owner, options: nil).first as AISingleCommentView
    }
}

extension AISingleCommentView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemNum = 8
        
        
        return itemNum
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CONTENT", forIndexPath: indexPath) as AICommentTagViewCell
        
        cell.maxWidth = collectionView.bounds.size.width
        cell.text = "text"
        
        return cell
    }


    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            indexPath.row
            
            var tagName = "text"

            let size = AICommentTagViewCell.sizeForCell(tagName,
                forMaxWidth: collectionView.bounds.size.width / 2)
            return size
    }

}
