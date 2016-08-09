//
//  ImagesReviewsViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/8/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class ImagesReviewViewController: UIViewController {
    
    var images: [Int: UIImage]!
    var delegate: ImagesReviewDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    class func loadFromXib() -> ImagesReviewViewController {
        let vc = ImagesReviewViewController(nibName: "ImagesReviewViewController", bundle: nil)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        loadImages()

    }
    
    private func setupNavigationBar() {
        extendedLayoutIncludesOpaqueBars = true
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "item_button_delete"), forState: .Normal)
        deleteButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]
        appearance.rightBarButtonItems = [deleteButton]
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor.clearColor(), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    private func loadImages() {
        if images.count == 0 {
            return
        }
        
        var index: Int = 0
        
        for imageInfo in images {
            let imageview = UIImageView(image: imageInfo.1)
            scrollView.addSubview(imageview)
            imageview.clipsToBounds = true
            imageview.tag = imageInfo.0
            imageview.contentMode = UIViewContentMode.ScaleAspectFit
            imageview.setLeft(UIScreen.mainScreen().bounds.width * (CGFloat(index)))
            imageview.setWidth(UIScreen.mainScreen().bounds.width)
            imageview.setHeight(UIScreen.mainScreen().bounds.height)
            
            index += 1
        }
    }
}

extension ImagesReviewViewController: UIScrollViewDelegate {
    
}

protocol ImagesReviewDelegate {
    func deleteImages(imageTags: [Int])
}
