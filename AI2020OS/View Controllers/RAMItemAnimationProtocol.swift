//
//  RAMItemAnimationProtocol.swift
//  AI2020OS
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//


import Foundation
import UIKit

protocol RAMItemAnimationProtocol {

    func playAnimation(icon : UIImageView, textLabel : UILabel)
    func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor)
    func selectedState(icon : UIImageView, textLabel : UILabel)
}

class RAMItemAnimation: NSObject, RAMItemAnimationProtocol {

    @IBInspectable var duration : CGFloat = 0.5;
    @IBInspectable var textSelectedColor: UIColor = UIColor.blackColor()
    @IBInspectable var iconSelectedColor: UIColor!

    func playAnimation(icon : UIImageView, textLabel : UILabel) {
    }

    func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
    }

    func selectedState(icon: UIImageView, textLabel : UILabel) {
    }
}
