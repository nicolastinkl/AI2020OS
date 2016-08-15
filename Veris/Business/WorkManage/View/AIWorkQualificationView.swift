//
//  AIWorkQualificationView.swift
//  AIVeris
//
//  Created by 刘先 on 8/9/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit
import iCarousel

class AIWorkQualificationView: UIView {
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var imageTitleLabel: UILabel!
    
    var items: [Int] = []
    //MARK: -> Constants
    
    
    //MARK: -> overrides
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSelfFromXib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for i in 0...99 {
            items.append(i)
        }
        
        setupViews()
    }
    
    func setupViews() {
        switchButton.setRoundBorder()
        switchButton.setButtonWidth()
        uploadButton.setRoundBorder()
        uploadButton.setButtonWidth()
        carousel.type = .Rotary
        carousel.dataSource = self
        carousel.delegate = self
    }
}


extension AIWorkQualificationView: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        
        //create new view if no view is available for recycling
        if (view == nil) {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame:CGRect(x:0, y:0, width:200, height:200))
            itemView.image = UIImage(named: "wm-icon2")
            itemView.contentMode = .Center
            
            label = UILabel(frame:itemView.bounds)
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.font = label.font.fontWithSize(50)
            label.tag = 1
            itemView.addSubview(label)
        } else {
            //get a reference to the label in the recycled view
            itemView = view as! UIImageView
            label = itemView.viewWithTag(1) as! UILabel!
        }
        
        //set item label
        //remember to always set any properties of your carousel item
        //views outside of the `if (view == nil) {...}` check otherwise
        //you'll get weird issues with carousel item content appearing
        //in the wrong place in the carousel
        label.text = "\(items[index])"
        
        return itemView
    }
    
    func carousel(carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
        AILog("offset: \(offset)")
        return transform
    }
    
    //占位视图的数量
    func numberOfPlaceholdersInCarousel(carousel: iCarousel) -> Int {
        return 3
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .Spacing {
            return value * 0.9
        }
        if option == iCarouselOption.Count {
            return 3
        }
        if option == iCarouselOption.Radius {
            return value * 2
        }
        if option == iCarouselOption.FadeMax {
            return 1
        }
        if option == iCarouselOption.FadeMinAlpha {
            return 0.5
        }
        return value
    }
}

extension UIButton {
    func setRoundBorder() {
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
    }
    
    func setButtonWidth() {
        let title = self.titleForState(UIControlState.Normal)
        let font = self.titleLabel?.font
        let buttonWidth = title!.sizeWithFont(font!, forWidth: 1000)
        self.snp_remakeConstraints { (make) in
            make.width.equalTo(buttonWidth.width + 20)
        }
    }
}
