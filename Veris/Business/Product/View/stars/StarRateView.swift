//
//  StarRateView.swift
//  AIVeris
//
//  Created by Rocky on 16/6/16.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class StarRateView: UIView {

    var foregroundStarView: UIView!
    var backgroundStarView: UIView!
    var delegate: StarRateViewDelegate?
    
    private var foregroundStars: [UIImageView]!
    private var backgroundStars: [UIImageView]!
    private var oldFrame: CGRect?
    
    @IBInspectable var scorePercent: CGFloat = 1.0
    @IBInspectable var hasAnimation: Bool = true
    @IBInspectable var allowIncompleteStar: Bool = true
    @IBInspectable var foregroundStarImage: String = "Yellow_Star"
    @IBInspectable var backgroundStarImage: String = "Gray_Star"
    @IBInspectable var numberOfStars: Int = 5
    
    override var frame: CGRect {
        didSet {
            oldFrame = frame
        }
    }
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, numberOfStars: 5)
    }
    
    init(frame: CGRect, numberOfStars: Int, foregroundImage: String? = nil, backgroundImage: String? = nil) {
        
        super.init(frame: frame)
        self.numberOfStars = numberOfStars
        
        if let fore = foregroundImage {
            foregroundStarImage = fore
        }
        
        if let back = backgroundImage {
            backgroundStarImage = back
        }
        
        buildDataAndUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildDataAndUI()
    }
    
    func userTapRateView(sender : UIGestureRecognizer) {
        let tapPoint = sender.locationInView(self)
        let offset = tapPoint.x
        let realStarScore: CGFloat = offset / bounds.size.width
        
        let starScore: CGFloat = allowIncompleteStar ? realStarScore : CGFloat(ceilf(Float(realStarScore)))

        setScorePercent(starScore)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let old = oldFrame {
            if old.height != frame.height || old.width != frame.width {
                relayoutStars()
                oldFrame = frame
            }
        } else {
            oldFrame = frame
        }
        
        let interval = self.hasAnimation ? 0.2 : 0
        weak var weakSelf: StarRateView? = self
        
        UIView.animateWithDuration(interval) {
            if let se = weakSelf {
                se.foregroundStarView.frame = CGRectMake(0, 0, se.bounds.size.width * se.scorePercent, se.bounds.size.height)
            }
            
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        relayoutStars()
    }
    
    private func buildDataAndUI() {
        foregroundStarView = createStarContainer()
        backgroundStarView = createStarContainer()
        
        foregroundStars = createStars(foregroundStarImage)
        backgroundStars = createStars(backgroundStarImage)
        
        addStarsToContainer(foregroundStarView, stars: foregroundStars)
        addStarsToContainer(backgroundStarView, stars: backgroundStars)
        
        addSubview(backgroundStarView)
        addSubview(foregroundStarView)
        
        
        let selector =
            #selector(StarRateView.userTapRateView(_:))
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        addGestureRecognizer(tapGesture)
    }
    
    private func createStars(imageName: String) -> [UIImageView] {
        var stars = [UIImageView]()
        
        for i in 0 ..< numberOfStars {
            let imageView = UIImageView(image: UIImage(named: imageName))
            
            let index: CGFloat = CGFloat(i)
            let numStars: CGFloat = CGFloat(numberOfStars)
            imageView.frame = CGRectMake(index * bounds.size.width / numStars, 0, bounds.size.width / numStars, bounds.size.height)
            
            imageView.contentMode = .ScaleAspectFit
            
            stars.append(imageView)
        }
        
        return stars
    }
    
    func relayoutStars() {
        guard let _ = foregroundStars else {
            return
        }
        
        foregroundStarView.frame = bounds
        backgroundStarView.frame = bounds
        
        for i in 0 ..< numberOfStars {
            let foregroundStar = foregroundStars[i]
            let backgroundStar = backgroundStars[i]
            
            let index: CGFloat = CGFloat(i)
            let numStars: CGFloat = CGFloat(numberOfStars)
            foregroundStar.frame = CGRectMake(index * bounds.size.width / numStars, 0, bounds.size.width / numStars, bounds.size.height)
            
            backgroundStar.frame = foregroundStar.frame
        }
    }
    
    private func createStarContainer() -> UIView {
        let view = UIView(frame: bounds)
        view.clipsToBounds = true
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }
    
    private func addStarsToContainer(container: UIView, stars: [UIImageView]) {
        let numStars: CGFloat = CGFloat(stars.count)
        
        for i in 0 ..< stars.count {
            let imageView = stars[i]
            
            let index: CGFloat = CGFloat(i)
            
            imageView.frame = CGRectMake(index * bounds.size.width / numStars, 0, bounds.size.width / numStars, bounds.size.height)
            container.addSubview(imageView)
        }
    }
    
    private func setScorePercent(percent: CGFloat) {
        if scorePercent == percent {
            return
        }
        
        if percent < 0 {
            scorePercent = 0
        } else if percent > 1 {
            scorePercent = 1
        } else {
            scorePercent = percent
        }
        
        delegate?.scroePercentDidChange(self, newScorePercent: scorePercent)
        
        setNeedsLayout()
    }

}

protocol StarRateViewDelegate {
    func scroePercentDidChange(starView: StarRateView, newScorePercent: CGFloat)
}