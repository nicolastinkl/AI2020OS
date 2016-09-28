//
//  AIAssetsReviewsController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// 相册预览界面
class AIAssetsReviewsController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var indexText: NSLayoutConstraint!
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var chooseAction: UIButton!
    
    @IBOutlet weak var sizeButton: UIButton!
    
    @IBOutlet weak var numberButton: UIButton!
    
    var assets: NSMutableArray = NSMutableArray()
    
    var assetsSelected = Array<NSDictionary>()
    
    var maximumNumberOfSelection: Int = 10
    
    private var isRetainImage: Bool = false
    
    private let selected: String = "selected"
    
    /// TODO:// This weak object from presous ViewController
    weak var delegate: AIAssetsPickerControllerDelegate?
            
    // MARK: -> Internal class methods
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0
        pageControl.hidden = true
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "0c93d9")
        pageControl.transform = CGAffineTransformMakeScale(0.8, 0.8)
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init..
        view.addSubview(pageControl)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Copy.
        assets.forEach { (value) in
            let dic = ["value": value, selected: true]
            assetsSelected.append(NSDictionary(dictionary: dic))
        }
        
        pageControl.pinToBottomEdgeOfSuperview(offset: 20, priority: UILayoutPriorityRequired)
        pageControl.centerHorizontallyInSuperview()
        
        refereshAlumArray(1)
        
    }
    
    func refereshButton() {
        let count: Int = assets.count
//        assetsSelected.forEach { (dict) in
//            if let bol = dict[selected] as? Bool {
//                if bol == true {
//                    count += 1
//                }
//            }
//        }
        numberButton.setTitle("\(count)/\(maximumNumberOfSelection) 上传", forState: UIControlState.Normal)
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func refereshAlumArray(indexs: Int) {
        
        if assets.count >= 1 {
            scrollView.contentSize = CGSizeMake(CGFloat(assets.count) * UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        }
        
        scrollView.subviews.forEach { (sview) in
            sview.removeFromSuperview()
        }
        // Add the album view controllers to the scroll view
        var index: Int = 1
        assets.forEach { (asset) in
            var image = UIImage(named: "")
            if asset is ALAsset {
                image = AIALAssetsImageOperator.thumbnailImageForAsset(asset as! ALAsset, maxPixelSize: 500)
            } else {
                image = asset as? UIImage
            }
            
            let imageview = UIImageView(image: image)
            scrollView.addSubview(imageview)
            imageview.clipsToBounds = true
            imageview.contentMode = UIViewContentMode.ScaleAspectFit
            imageview.setLeft(UIScreen.mainScreen().bounds.width*(CGFloat(index)-1))
            imageview.setWidth(UIScreen.mainScreen().bounds.width)
            imageview.setHeight(UIScreen.mainScreen().bounds.height)
            imageview.tag = index
            index += 1
        }
        pageControl.numberOfPages = assets.count
        
        indexLabel.text = "\(indexs)/\(assets.count)"
        
        refereshButton()
    }
    
    @IBAction func choooseAction(sender: AnyObject) {
        
        let index = pageControl.currentPage
        let alertView = UIAlertController(title: "", message: "要删除这张照片吗？", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let a1 = UIAlertAction(title: "删除", style: UIAlertActionStyle.Default) { (action) in
            self.assets.removeObjectAtIndex(index)
            self.refereshAlumArray(index)
        }
        let a2 = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (action) in
            
        }
        alertView.addAction(a1)
        alertView.addAction(a2)
        
        showTransitionStyleCrossDissolveView(alertView)
        
        
//        let dict = assetsSelected[index]
//        if let bol = dict.valueForKey(selected) as? Bool {
//            var newBol = bol
//            newBol = !newBol
//            
//            if newBol {
//                chooseButton.setImage(UIImage(named: "UINaviDisable"), forState: UIControlState.Normal)
//            } else {
//                chooseButton.setImage(UIImage(named: "UINaviAble"), forState: UIControlState.Normal)
//            }
//            let newDict = dict
//            //newDict.setValue(newBol, forKey: selected)
//            assetsSelected[index] = newDict
//        }
        
//        refereshButton()
        
    }
    
    /// 完成选择相册事件
    @IBAction func finishChooseAlumAction(sender: AnyObject) {
        delegate?.assetsPickerController(AIAssetsPickerController(), didFinishPickingAssets: assets)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width
        pageControl.currentPage = Int(index)
        indexLabel.text = "\(Int(index)+1)/\(assets.count)"
        
    }
    
    @IBAction func retainAction(sender: AnyObject) {
        isRetainImage = !isRetainImage
        refershDataSize()
    }
    
    func refershDataSize() {
        if isRetainImage {
            var size = 0
            assets.forEach({ (assetObj) in                
                let representation = assetObj.defaultRepresentation()
                let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
                let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                    length: Int(representation.size()), error: nil)
                let dataImageFull: NSData =  NSData(bytesNoCopy:imageBuffer, length:bufferSize, freeWhenDone:true)
                size += dataImageFull.length
                
            })
            let newSizeMB = Double(size/1024/1024)
            
            if size/1024 < 1000 {
                sizeButton.setTitle(" 原图(\(size/1024)KB)", forState: UIControlState.Normal)
            } else {
                sizeButton.setTitle(" 原图(\(newSizeMB)MB)", forState: UIControlState.Normal)
            }
            
            sizeButton.setImage(UIImage(named: "UINaviAble"), forState: UIControlState.Normal)
        } else {
            sizeButton.setTitle(" 原图", forState: UIControlState.Normal)
            sizeButton.setImage(UIImage(named: "UINaviDisable"), forState: UIControlState.Normal)
        }
    }
}
