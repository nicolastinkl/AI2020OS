//
//  AbsCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/17.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import MobileCoreServices

class AbsCommentViewController: UIViewController {


}

extension AbsCommentViewController: UINavigationControllerDelegate {

}

extension AbsCommentViewController: CommentDistrictDelegate {
    func pohotImageButtonClicked(button: UIImageView, buttonParent: UIView) {
        let alert = UIAlertController(title: nil, message: "AbsCommentViewController.selectSrc".localized, preferredStyle: .ActionSheet)

        let actionCamera = UIAlertAction(title: "Camera".localized, style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startCameraControllerFromViewController(self, delegate: self)
        }

        let actionPhotosAlbum = UIAlertAction(title: "Gallery".localized, style: .Default) { (UIAlertAction) in
            BuildInCameraUtils.startMediaBrowserFromViewController(self, delegate: self)
        }

        let actionCancel = UIAlertAction(title: "AIAudioMessageView.close".localized, style: .Cancel, handler: nil)

        alert.addAction(actionCamera)
        alert.addAction(actionPhotosAlbum)
        alert.addAction(actionCancel)

        presentViewController(alert, animated: true, completion: nil)
    }
}

extension AbsCommentViewController: UIImagePickerControllerDelegate {
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
                imagePicked(image)
            }
        }

        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePicked(image: UIImage) {

    }
}
