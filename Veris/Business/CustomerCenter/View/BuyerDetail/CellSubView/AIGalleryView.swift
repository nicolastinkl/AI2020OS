//
//  AIGalleryView.swift
//  AIVeris
//
//  Created by tinkl on 19/11/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import UIKit

/// 相册
internal class AIGalleryView: UIView, UIScrollViewDelegate {

    // MARK: -> Internal class methods


    class func defaultTag () -> NSInteger {
        return (Int)(99999 + (arc4random() % 9999999))
    }


    var imageModelArray: [String]? {
        didSet {
            guard let imageArray = imageModelArray else { return }

            //var pageViews: [UIView] = []
            var index: Int = 0
            for url in imageArray {

                let imageView = AIImageView()
                //imageView.image = smallPlace()
                imageView.contentMode = .ScaleAspectFill
                imageView.setImgURL(NSURL(string: url), placeholderImage: smallPlace())
                imageView.clipsToBounds = true
                self.pageScrollView.addSubview(imageView)
                imageView.frame = pageScrollView.frame
                imageView.setLeft(CGFloat(index) * imageView.width)
                //pageViews.append(imageView)
                index = index + 1
            }
            self.pageControl.numberOfPages = imageArray.count
            self.pageScrollView.contentSize = CGSizeMake(pageScrollView.width * CGFloat(imageArray.count), pageScrollView.height)
        }
    }



    func initPageControl() {
        pageControl = UIPageControl()
        pageControl.numberOfPages = self.imageModelArray?.count ?? 0
        pageControl.currentPage = 0
        pageControl.transform = CGAffineTransformMakeScale(0.8, 0.8)
        pageControl.tag = 12
    }
    private var pageControl: UIPageControl!

    
    func initPageScrollView() {
        // Setup the paging scroll view
        pageScrollView = UIScrollView()
        pageScrollView.backgroundColor = UIColor.clearColor()
        pageScrollView.pagingEnabled = true
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.userInteractionEnabled = true
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.tag = 12
    }
    private var pageScrollView: UIScrollView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.userInteractionEnabled = true
        initPageControl()
        initPageControl()
        self.addSubview(pageScrollView)
        pageScrollView.frame = frame

        self.addSubview(pageControl)
        let point = CGPointMake((self.width - pageControl.width)/2, self.height - 10)
        pageControl.setX(point.x)
        pageControl.setY(point.y)
        pageScrollView.delegate = self

        /**
        guard let superScroll = scrollView() else { return }

        let ges = self.pageScrollView.gestureRecognizers?.last!
        if let g =  superScroll.gestureRecognizers?.last {
        g.requireGestureRecognizerToFail(ges!)
        }
        */
    }

    init() {
        super.init(frame: CGRect.zero)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width
        pageControl.currentPage = Int(index)
    }


    // MARK: -
    // MARK: Methods (Public)

    private func scrollView() -> UIScrollView? {
        return superview as? UIScrollView
    }
}
