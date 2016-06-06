//
//  ServiceCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/2.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import MobileCoreServices


class ServiceCommentViewController: UIViewController {

    @IBOutlet weak var starsContainerView: UIView!
    @IBOutlet weak var starsDes: UILabel!
    @IBOutlet weak var commentDistrict: CommentDistrictView!
    
    var starRateView: CWStarRateView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if starRateView == nil {
            starRateView = CWStarRateView(frameAndImage: starsContainerView.frame, numberOfStars: 5, foreground: "review_star_yellow", background: "review_star_gray")
            starRateView.userInteractionEnabled = true
            view.addSubview(starRateView)
            
            starRateView.snp_makeConstraints { (make) in
                make.edges.equalTo(starsContainerView)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ServiceCommentViewController: UINavigationControllerDelegate {
    
}

extension ServiceCommentViewController: CommentDistrictDelegate {
    func pohotImageButtonClicked(button: UIImageView) {
        let alert = UIAlertController(title: nil, message: "选择图片来源", preferredStyle: .ActionSheet)
        
        let actionCamera = UIAlertAction(title: "相机", style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
        }
        
        let actionPhotosAlbum = UIAlertAction(title: "相册", style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startMediaBrowserFromViewController(self, delegate: self)
        }
        
        let actionCancel = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        
        alert.addAction(actionCamera)
        alert.addAction(actionPhotosAlbum)
        alert.addAction(actionCancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension ServiceCommentViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
            var imageToSave: UIImage?
            
            if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                imageToSave = editedImage
            } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageToSave = originalImage
            }
            
            if picker.sourceType == .Camera {
                let imageMetadata = info[UIImagePickerControllerMediaMetadata] as! NSDictionary
                print("")
            }
            
            
            
            if let image = imageToSave {
                commentDistrict.photoImage.image = image
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
