//
//  AIAssetsViewCell.swift
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

/// Photo Cell
class AIAssetsViewCell: UICollectionViewCell {
    
    var model:AIAssetsPickerModel?
    
    private var asset: ALAsset?
    
    private var image: UIImage?
    
    private var type: String = ""
    
    private var checkedIcon: UIImage = UIImage(named: "UINaviHaschecked")!
    private var uncheckedIcon: UIImage = UIImage(named: "UINaviunChecked")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(assetSuper: ALAsset){
        asset = assetSuper
        image = UIImage(CGImage: assetSuper.thumbnail().takeUnretainedValue())
        type = assetSuper.valueForProperty(ALAssetPropertyType) as! String
    }
    
    override var selected: Bool {
        didSet{
            setNeedsDisplay()
        }
    }
    
    // Draw everything to improve scrolling responsiveness
    override func drawRect(rect: CGRect) {
        self.image?.drawInRect(CGRectMake(0, 0, 100, 100))
        
        var imageSelect: UIImage = uncheckedIcon
        if (self.selected) {
            imageSelect = checkedIcon
        }else{
            imageSelect = uncheckedIcon
        }
        
        let x = CGRectGetMaxX(rect) - checkedIcon.size.width - 3
        let y = CGRectGetMinY(rect) + 3
        
        imageSelect.drawAtPoint(CGPointMake(x,y))
    }
}

/// FootView
class AIAssetsFootViewCell: UICollectionReusableView {
    
    private var sectionLabel: UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sectionLabel.frame = CGRectInset(self.bounds, 8.0, 8.0)
        sectionLabel.textAlignment = .Center
        sectionLabel.font = AITools.myriadBoldWithSize(16)
        sectionLabel.textColor = UIColor.whiteColor()
        self.addSubview(sectionLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNumberOfPhotos(photos: Int){
        sectionLabel.text = "照片\(photos)张"
    }
    
}