//
//  ImagesReviewsViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/8/5.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import Foundation

class ImagesReviewViewController: UIViewController {
    
    var images: [(imageId: String, UIImage)]!
    var dataSource = [(id: String, UIImage)]()
    var deleteImages = [String]()
    var delegate: ImagesReviewDelegate?
    private var currentIndex = 0

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
        updateTitle()
    }
    
    
    
    private func setupNavigationBar() {
//        extendedLayoutIncludesOpaqueBars = true
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(ImagesReviewViewController.dismissController), forControlEvents: .TouchUpInside)
        
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(named: "item_button_delete"), forState: .Normal)
        deleteButton.setSize(CGSize(width: 196.displaySizeFrom1242DesignSize(), height: 80.displaySizeFrom1242DesignSize()))
        deleteButton.addTarget(self, action: #selector(ImagesReviewViewController.deleteImage), forControlEvents: .TouchUpInside)
        
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
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: getTitle())
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    private func loadImages() {
        if images.count == 0 {
            return
        }
        
        for imageInfo in images {
            dataSource.append((imageInfo.0, imageInfo.1))
        }
        
        setScrollViewContent()
    }
    
    func deleteImage() {
        if dataSource.count == 0 {
            return
        }
        
        deleteImages.append(dataSource[currentIndex].id)
        
        dataSource.removeAtIndex(currentIndex)
        
        updateImages()
        updateTitle()
    }
    
    func dismissController() {
        dismissViewControllerAnimated(true) { 
            if self.deleteImages.count > 0 {
                self.delegate?.deleteImages(self.deleteImages)
            }
        }
    }
    
    private func updateTitle() {
        title = getTitle()
    }
    
    private func getTitle() -> String {
        let total = dataSource.count
        return "\(currentIndex + 1)/\(total)"
    }
    
    private func updateImages() {
        for sub in scrollView.subviews {
            sub.removeFromSuperview()
        }
        
        if currentIndex > 0 {
            currentIndex -= 1
        }
        
        if dataSource.count == 0 {
            dismissController()
        } else {
            setScrollViewContent()
            
            moveToCurrentIndex()
        }
    }
    
    private func setScrollViewContent() {
        let imageWidth = UIScreen.mainScreen().bounds.width
        let imageHeight = scrollView.height
        
        if dataSource.count >= 1 {
            scrollView.contentSize = CGSizeMake(CGFloat(dataSource.count) * imageWidth, imageHeight)
        }
        
        var index: Int = 0
        
        for data in dataSource {
            let imageview = UIImageView(image: data.1)
            scrollView.addSubview(imageview)
            imageview.clipsToBounds = true
            imageview.contentMode = UIViewContentMode.ScaleAspectFit
            imageview.snp_makeConstraints(closure: { (make) in
                make.leading.equalTo(imageWidth * (CGFloat(index)))
                make.top.equalTo(0)
                make.width.equalTo(view)
                make.height.equalTo(view)
            })
            index += 1
        }
    }
    
    private func moveToCurrentIndex() {
        let imageWidth = UIScreen.mainScreen().bounds.width
        let imageHeight = scrollView.height
        
        let currentRect = CGRect(origin: CGPoint(x: CGFloat(currentIndex) * imageWidth, y: 0), size: CGSize(width: imageWidth, height: imageHeight))
        
        scrollView.scrollRectToVisible(currentRect, animated: true)
    }
}

extension ImagesReviewViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let indexf = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width
        currentIndex = Int(indexf)
        updateTitle()
    }
}

protocol ImagesReviewDelegate {
    func deleteImages(imageIds: [String])
}
