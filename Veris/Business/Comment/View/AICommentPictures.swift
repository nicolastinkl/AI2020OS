//
//  AICommentPictures.swift
//  AIVeris
//
//  Created by 王坜 on 16/8/19.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICommentPictures: UIView {

    //MARK: Properties

    var displayPictureNames = [String]()
    var displayPictures = [UIImageView]()

    var delegate: AICommentPicturesDelegate?
    //MARK: init


    init(frame: CGRect, pictures: [String]) {
        super.init(frame: frame)
        appendPictures(pictures)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: func


    func makePicture(frame: CGRect, picture: AnyObject, tag: Int) -> UIImageView {

        let imageView = AIImageView(frame: frame)

        if picture is String {
            let url = NSURL(string: picture as! String)
            imageView.sd_setImageWithURL(url, placeholderImage: nil)
        } else if picture is UIImage {
            imageView.image = picture as? UIImage
            imageView.uploadImage("\(tag)", complate: { (id, url, error) in
                self.displayPictureNames.append((url?.absoluteString)!)
            })
        }

        imageView.userInteractionEnabled = true
        imageView.frame = frame
        imageView.exclusiveTouch = true
        // Add Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapAction(_:)))
        imageView.addGestureRecognizer(tapGesture)

        return imageView
    }



    func appendPictures(pictures: [AnyObject]) {

        if pictures.count == 0 {
            return
        }

        var index: Int = displayPictureNames.count

        if pictures.first is String {
            displayPictureNames.appendContentsOf(pictures as! [String])
        }

        let margin: CGFloat = 16.displaySizeFrom1242DesignSize()
        let size: CGFloat = 220.displaySizeFrom1242DesignSize()
        var xoffset: CGFloat = 0
        var yoffset: CGFloat = 0
        var shouldNextLine = false


        if let lastImageView = displayPictures.last {
            xoffset = CGRectGetMaxX(lastImageView.frame) + margin
            yoffset = CGRectGetMinY(lastImageView.frame)
            shouldNextLine = (xoffset + size) > CGRectGetWidth(self.frame)
            if shouldNextLine {
                xoffset = 0
                yoffset = CGRectGetMaxY(lastImageView.frame) + margin
            }
        }

        var x: CGFloat = xoffset
        var y: CGFloat = yoffset

        for picture in pictures {

            let frame = CGRect(x: x, y: y, width: size, height: size)
            let imageView = makePicture(frame, picture: picture, tag: index)
            self.addSubview(imageView)
            displayPictures.append(imageView)

            index += 1
            x += size + margin
            if x > CGRectGetWidth(self.frame) {
                x = 0
                y += size + margin
            }
        }

        reframeSelf()

    }


    func reframeSelf() {

        var frame = self.frame

        if let lastImageView = displayPictures.last {
            let height = CGRectGetMaxY(lastImageView.frame)
            frame.size.height = height
        } else {
            frame.size.height = 0
        }

        self.frame = frame
        self.delegate?.didChangedHeight(height)
    }

    func imageTapAction(tapGesture: UITapGestureRecognizer) {

        let imageView = tapGesture.view as! UIImageView
        self.delegate?.didSelectedPictures(displayPictures, index: imageView.tag)
    }

    func deletePictures(pictures: [Int]) {
        for index in pictures {
            displayPictureNames.removeAtIndex(index)
            displayPictures.removeAtIndex(index)
        }

        var curNames = [String]()
        var curPictures = [UIImageView]()
        curNames.appendContentsOf(displayPictureNames)
        curPictures.appendContentsOf(displayPictures)

        displayPictureNames.removeAll()
        displayPictures.removeAll()

        appendPictures(displayPictureNames)


    }

}


@objc protocol AICommentPicturesDelegate {
    func didSelectedPictures(pictures: [UIImageView], index: Int)

    func didChangedHeight(height: CGFloat)

}
