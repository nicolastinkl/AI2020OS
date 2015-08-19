//
//  AISingleEvaluationViewCellTableViewCell.swift
//  AI2020OS
//
//  Created by admin on 15/8/13.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISingleCommentView: UIView {
    
    @IBOutlet weak var avatar: AIRoundImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tipsCollectionView: UICollectionView!
    @IBOutlet weak var tipsLabel: UILabel!
    
    var scopeView: AIServerScopeView!
    
    var commentData: AIServiceComment? {
        didSet {
            
            if commentData != nil {
                if commentData!.provider_portrait_url != nil {
                    avatar.setURL(NSURL(string: commentData!.provider_portrait_url!), placeholderImage:UIImage(named: "Placeholder"))
//                    AIImageViewUtils.loadImageFromUrl(avatar, url: commentData!.provider_portrait_url!, placeholderImage: UIImage(named: "Placeholder")!)
                }
                
                if commentData!.comment_tags != nil {
                    collectionView.reloadData()
                }
            }
        }
    }
    
    var tipsData: [AITipModel]? {
        didSet {
            if tipsData != nil {
           //     tipsCollectionView.reloadData()
                var models = [ServerScopeModel]()
                
                for var index = 0; index < tipsData!.count; ++index {
                    var scopeModel = ServerScopeModel(outId: "\(index)", outContent: tipsData![index].desc)
                    models.append(scopeModel)
                }
                
                if scopeView == nil {
                    scopeView = AIServerScopeView.currentView()
                }
                
                if tipButtonSize != nil {
                    scopeView!.buttonSize = tipButtonSize
                }
                scopeView!.initWithViewsArray(models, parentView: self)
                scopeView!.frame = CGRectMake(collectionView.frame.origin.x, tipsLabel.bottom + 10, collectionView.frame.width, 40)
             //   scopeView!.setTop(tipsLabel.bottom + 10)
                
                addSubview(scopeView!)
            }
        }
    }
    
    var tipButtonSize: CGSize?
    var buttonMargin: CGFloat {
        get {
            if scopeView == nil {
                return 0
            } else {
                return scopeView!.tagMargin
            }
        }
        
        set {
            scopeView?.tagMargin = newValue
        }
    }
    
    override func awakeFromNib() {
        
        collectionView.registerClass(AICommentTagViewCell.self,
            forCellWithReuseIdentifier: "CONTENT")
        tipsCollectionView.registerClass(AICommentTagViewCell.self,
            forCellWithReuseIdentifier: "CONTENT")

        scopeView = AIServerScopeView.currentView()
        
        setTextFieldStyle()
  //      setTipsView()

  //      NSBundle.mainBundle().loadNibNamed("AISingleEvaluationView", owner: self, options: nil)
        
  //      addSubview(contentView)

    }
    
    class func instance(owner: AnyObject!) -> AISingleCommentView {
        return NSBundle.mainBundle().loadNibNamed("AISingleCommentView", owner: owner, options: nil).first as AISingleCommentView
    }
    
    private func setTextFieldStyle() {
        let color = UIColor(rgba: "#a7a7a7").CGColor
        let lineLayer =  CALayer()
        lineLayer.backgroundColor = color
        lineLayer.frame = CGRectMake(0, textField.height - 1, textField.width, 0.5)
        textField.layer.addSublayer(lineLayer)
    }
    
    private func setTipsView() {
        let scopeView =  AIServerScopeView.currentView()
        scopeView.initWithViewsArray([
            ServerScopeModel(outId: "2", outContent: "+5元"),
            ServerScopeModel(outId: "6", outContent: "+10元"),
            ServerScopeModel(outId: "3", outContent: "自定义")], parentView: self)
        scopeView.setTop(tipsLabel.bottom + 10)
        
        addSubview(scopeView)
        
//        var tips = [AITipModel]()
//        var tip = AITipModel()
//        tip.value = 5
//        tip.desc = "+5元"
//        tips.append(tip)
//        
//        tip = AITipModel()
//        tip.value = 5
//        tip.desc = "+10元"
//        tips.append(tip)
//        
//        tip = AITipModel()
//        tip.value = 5
//        tip.desc = "自定义"
//        tips.append(tip)
//        
//        self.tipsData = tips
    }
}

extension AISingleCommentView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            if commentData == nil {
                return 0
            } else if commentData!.comment_tags == nil {
                return 0
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            if commentData == nil {
                return 0
            } else if commentData!.comment_tags == nil {
                return 0
            } else {
                return commentData!.comment_tags!.count
            }
        } else {
            if tipsData == nil {
                return 0
            } else {
                return 0
            }
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CONTENT", forIndexPath: indexPath) as AICommentTagViewCell
        
        cell.maxWidth = collectionView.bounds.size.width
        
        if collectionView == self.collectionView {
            cell.text = commentData!.comment_tags![indexPath.row].content?
        } else if collectionView == self.tipsCollectionView {
            cell.text = tipsData![indexPath.row].desc
            cell.setWidth(collectionView.bounds.size.width / 3 - 10)
        }
        
        return cell
    }


    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            var size: CGSize
            
            if collectionView == self.collectionView {
                var tagContent = commentData!.comment_tags![indexPath.row].content?
                
                if tagContent == nil {
                    size = CGSize(width: 0, height: 0)
                } else {
                    size = AICommentTagViewCell.sizeForCell(tagContent!,
                        forMaxWidth: collectionView.bounds.size.width / 2)
                    
                }
            } else {
                var tipContent = self.tipsData![indexPath.row].desc
                let btnSize = AICommentTagViewCell.sizeForCell(tipContent!,
                    forMaxWidth: collectionView.bounds.size.width / 2)
                size = CGSize(width: collectionView.bounds.size.width / 3 - 10, height: btnSize.height)
            }
            
            return size
            
    }

}
