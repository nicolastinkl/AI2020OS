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
    
    var commentData: AIServiceComment? {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        if commentData == nil {
            return 0
        } else if commentData!.comment_tags == nil {
            return 0
        } else {
            return 1
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if commentData == nil {
            return 0
        } else if commentData!.comment_tags == nil {
            return 0
        } else {
            return commentData!.comment_tags!.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CONTENT", forIndexPath: indexPath) as AICommentTagViewCell
        
        cell.maxWidth = collectionView.bounds.size.width
        cell.text = commentData!.comment_tags![indexPath.row].content?
        
        return cell
    }


    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            var tagContent = commentData!.comment_tags![indexPath.row].content?
            
            if tagContent == nil {
                return CGSize(width: 0, height: 0)
            } else {
                let size = AICommentTagViewCell.sizeForCell(tagContent!,
                    forMaxWidth: collectionView.bounds.size.width / 2)
                return size
            }

            
    }

}
