//
//  ImagesCollectionView.swift
//  AIVeris
//
//  Created by Rocky on 16/6/29.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ImagesCollectionView: UIView {

    var images: [AIImageView]!
    var delegate: ImagesCollectionProtocol?
    private static let noLimitRow = 0
    
    private var row = 0
    private var column = 0
    
    @IBInspectable var imageHeight: CGFloat = 20.0 {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var imageWidth: CGFloat = 20.0 {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var verticalSpace: CGFloat = 5.0 {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var horizontalSpace: CGFloat = 5.0 {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var lines: Int = noLimitRow { // 0 means no limit
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }
    
    @IBInspectable var botomToTop: Bool = false {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSelf()
    }
    
    private func initSelf() {
        images = [AIImageView]()
    }

    override func intrinsicContentSize() -> CGSize {
        var size = CGSize(width: bounds.width, height: bounds.height)
        
        var row = caculateRow()
        
        if lines > 0 && row > lines {
            row = lines
        }
        
        size.height = (imageHeight + verticalSpace) * CGFloat(row) - verticalSpace
        
        return size
    }
    
    override func layoutSubviews() {
        let colunm = maxColunm()
        
        var index = 0
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        var row = 0
        
        if botomToTop {
            offsetY = height - imageHeight
        }
        
        if lines < 0 {
            lines = 0
        }
        
        for image in images {
            image.frame.origin.x = offsetX
            image.frame.origin.y = offsetY
            
            if self != image.superview {
                addSubview(image)
            }
            
            offsetX += image.size.width
            offsetX += horizontalSpace
            
            if index == colunm - 1 {
                offsetX = 0
                
                if botomToTop {
                    offsetY -= (verticalSpace + image.height)
                } else {
                    offsetY += (verticalSpace + image.height)
                }
                
                index = 0
                
                row += 1
                
                if lines != ImagesCollectionView.noLimitRow {
                    if lines > 0 && row == lines {
                        break
                    }
                }    
            }
            
            index += 1
        }
    }
    
    func addImage(image: UIImage, imageId: String? = nil) {
        appendImage(image)
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    func addImages(images: [(image: UIImage, imageId: String?)]) {
        for imageItem in images {
            appendImage(imageItem.image, imageId: imageItem.imageId)
        }
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    func addAsyncUploadImages(images: [(image: UIImage, imageId: String?, complate: AIImageView.UploadComplate?)]) {
        for image in images {
            appendAsyncUploadImage(image.image, imageId: image.imageId, complate: image.complate)
        }
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    func addAsyncUploadImage(image: UIImage, imageId: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        appendAsyncUploadImage(image, imageId: imageId, complate: complate)
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    func addAsyncDownloadImages(urls: [(url: NSURL, imageId: String?)], holdImage: UIImage? = nil) {
        for urlItem in urls {
            let imageView = createImageView(urlItem.imageId)
            imageView.setURL(urlItem.url, placeholderImage: holdImage, showProgress: true)
            images.append(imageView)
        }
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    func addAssetImages(urls: [(url: NSURL, imageId: String?)]) {
        for urlItem in urls {
            let imageView = createImageView(urlItem.imageId)
            images.append(imageView)
            imageView.loadFromAsset(urlItem.url)      
        }
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    private func appendImage(image: UIImage, imageId: String? = nil) {
        let imageView = createImageView(imageId)
        imageView.image = image
        
        images.append(imageView)
    }
    
    private func appendAsyncUploadImage(image: UIImage, imageId: String? = nil, complate: AIImageView.UploadComplate? = nil) {
        let imageView = createImageView(imageId)
        imageView.image = image
        imageView.uploadImage(imageId, complate: complate)
        images.append(imageView)
    }
    
    func clearImages() {
        
        for imageView in images {
            imageView.removeFromSuperview()
        }
        
        images.removeAll()
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }
    
    func deleteImages(imageIds: [String]) {
        for id in imageIds {
            for imageView in images {
                if imageView.imageId == id {
                    imageView.removeFromSuperview()       
                }
            }
        }
        
        let keepedImages = images.filter { (imageView) -> Bool in
            if imageView.imageId == nil {
                return false
            }
            
            return !imageIds.contains(imageView.imageId!)
        }
        
        images = keepedImages
        
        setNeedsUpdateConstraints()
        setNeedsLayout()
        
    }
    
    private func createImageView(imageId: String?) -> AIImageView {
        let imageView = AIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight))
        imageView.userInteractionEnabled = true
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(ImagesCollectionView.imageAction(_:)))
        imageView.addGestureRecognizer(tapGuesture)
        
        if let id = imageId {
            imageView.imageId = id
        } else {
            imageView.imageId = "\(NSDate().timeIntervalSince1970)"
        }
        
        return imageView
    }
    
    private func maxColunm() -> Int {
        let maxColunm: Int = Int((bounds.width + horizontalSpace) / (imageWidth + horizontalSpace))
        return maxColunm
        
    }
    
    private func caculateRow() -> Int {
        let maxColunm = self.maxColunm()
        
        var row = images.count / maxColunm
        
        let m = images.count % maxColunm
        
        if m != 0 {
            row += 1
        }
        
        return row
    }
    
    func imageAction(sender: UITapGestureRecognizer) {
        if let image = sender.view as? AIImageView {
            delegate?.imageClicked(image.image, imageId: image.imageId)
        }
        
    }
    
    
}

protocol ImagesCollectionProtocol {
    func imageClicked(image: UIImage?, imageId: String?)
}
