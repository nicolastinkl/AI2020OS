//
//  AIViewController.swift
//  AI2020OS
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

import UIKit

class AIDiscoveryViewController: UIViewController , RAReorderableLayoutDelegate, RAReorderableLayoutDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var imagesForSection0: [UIImage] = []
    var imagesForSection1: [UIImage] = []
    var imagesForSection2: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "发现"
        
        let nib = UINib(nibName: "verticalCell", bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        self.imagesForSection0.append(UIImage(named: "Home_discover_01")!)
//        
//        self.imagesForSection1.append(UIImage(named: "Home_discover_02")!)
//        self.imagesForSection1.append(UIImage(named: "Home_discover_03")!) 
        
        self.view.showBuildingView("敬请期待")
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Home_page_weather_bg"), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, 0, 0)
    }
    
    // RAReorderableLayout delegate datasource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let threePiecesWidth = floor(screenWidth / 3.0 - ((2.0 / 3) * 2))
        let twoPiecesWidth = floor(screenWidth / 2.0 - (2.0 / 2))
        let onePiecesWidth = floor(screenWidth / 1.0 - (2.0 / 2))
        
        if indexPath.section == 0 {
            return CGSizeMake(onePiecesWidth, onePiecesWidth)
        }else if indexPath.section == 1  {
            return CGSizeMake(twoPiecesWidth, twoPiecesWidth)
        }else if indexPath.section == 2  {
            return CGSizeMake(threePiecesWidth, threePiecesWidth)
        }
        return CGSizeMake(threePiecesWidth, threePiecesWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.imagesForSection0.count
        }else if section == 1{
            return self.imagesForSection1.count
        }else if section == 2{
            return self.imagesForSection2.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("verticalCell", forIndexPath: indexPath) as RACollectionViewCell
        
        if indexPath.section == 0 {
            cell.imageView.image = self.imagesForSection0[indexPath.item]
        }else if indexPath.section == 1 {
            cell.imageView.image = self.imagesForSection1[indexPath.item]
        }else if indexPath.section == 2 {
            cell.imageView.image = self.imagesForSection2[indexPath.item]
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, allowMoveAtIndexPath indexPath: NSIndexPath) -> Bool {
        if collectionView.numberOfItemsInSection(indexPath.section) <= 1 {
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, atIndexPath: NSIndexPath, didMoveToIndexPath toIndexPath: NSIndexPath) {
        var photo: UIImage = UIImage()
        if atIndexPath.section == 0 {
            photo = self.imagesForSection0.removeAtIndex(atIndexPath.item)
        }else if atIndexPath.section == 1 {
            photo = self.imagesForSection1.removeAtIndex(atIndexPath.item)
        }else if atIndexPath.section == 2 {
            photo = self.imagesForSection2.removeAtIndex(atIndexPath.item)
        }
        
        if toIndexPath.section == 0 {
            self.imagesForSection0.insert(photo, atIndex: toIndexPath.item)
        }else if toIndexPath.section == 1 {
            self.imagesForSection1.insert(photo, atIndex: toIndexPath.item)
        }else if toIndexPath.section == 2 {
            self.imagesForSection2.insert(photo, atIndex: toIndexPath.item)
        }
    }
    
    func scrollTrigerEdgeInsetsInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
    }
    
    func collectionView(collectionView: UICollectionView, reorderingItemAlphaInSection section: Int) -> CGFloat {
        return 0.3
    }
    
    func scrollTrigerPaddingInCollectionView(collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(self.collectionView.contentInset.top, 0, self.collectionView.contentInset.bottom, 0)
    }
}

class RACollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var gradientLayer: CAGradientLayer?
    var hilightedCover: UIView!
    override var highlighted: Bool {
        didSet {
            self.hilightedCover.hidden = !self.highlighted
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.hilightedCover.frame = self.bounds
        self.applyGradation(self.imageView)
    }
    
    private func configure() {
        self.imageView = UIImageView()
        self.imageView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(self.imageView)
        
        self.hilightedCover = UIView()
        self.hilightedCover.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.hilightedCover.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.hilightedCover.hidden = true
        self.addSubview(self.hilightedCover)
    }
    
    private func applyGradation(gradientView: UIView!) {
        self.gradientLayer?.removeFromSuperlayer()
        self.gradientLayer = nil
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer!.frame = gradientView.bounds
        
        let mainColor =  UIColor(white: 0, alpha: 0.3).CGColor
        let subColor = UIColor.clearColor().CGColor
        self.gradientLayer!.colors = [subColor, mainColor]
        self.gradientLayer!.locations = [0, 1]
        
        gradientView.layer.addSublayer(self.gradientLayer)
    }
}