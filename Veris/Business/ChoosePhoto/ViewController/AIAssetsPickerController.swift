//
//  AIAssetsPickerController.swift
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
import AssetsLibrary
import SVProgressHUD

/// 调用委托
protocol AIAssetsPickerControllerDelegate: class {
	
	/**
	 完成选择

	 1. 缩略图： UIImage(CGImage: assetSuper.thumbnail().takeUnretainedValue())
	 2. 完整图： UIImage(CGImage: assetSuper.fullResolutionImage().takeUnretainedValue())
	 */
	func assetsPickerController(picker: AIAssetsPickerController, didFinishPickingAssets assets: NSArray)
	
	/**
	 取消选择
	 */
	func assetsPickerControllerDidCancel()
	
	/**
	 选中某张照片
	 */
	func assetsPickerController(picker: AIAssetsPickerController, didSelectItemAtIndexPath indexPath: NSIndexPath)
    
	/**
	 取消选中某张照片
	 */
	func assetsPickerController(picker: AIAssetsPickerController, didDeselectItemAtIndexPath indexPath: NSIndexPath)
	
}

enum AIAssetsPickerModel: Int {
	case singleModel
	case mutliModel
}

/// How to use it ?
/**
 let vc = AIAssetsPickerController.initFromNib()
 vc.delegate = self
 vc.choosePhotoModel = .mutliModel
 .....
 */

/// 相册界面
class AIAssetsPickerController: UIViewController {

    var choosePhotoModel: AIAssetsPickerModel = .mutliModel  //default value.
    
    var maximumNumberOfSelection: Int = 10 //default
    
    weak var delegate: AIAssetsPickerControllerDelegate?
    
    @IBOutlet weak var collctionView: UICollectionView!
    
    @IBOutlet weak var sizeButton: UIButton!
    
    @IBOutlet weak var numberButton: UIButton!
    
    @IBOutlet weak var layoutColl: UICollectionViewFlowLayout!
    
    private let selectionFilter = NSPredicate(value: true)
    
    private var assets: NSMutableArray = NSMutableArray()
    
    private var assetsLibrary: ALAssetsLibrary = ALAssetsLibrary()
    
    private var groups: NSMutableArray = NSMutableArray()
    
    private var numberOfPhotos: Int = 0
    
    private var assetsGroup: ALAssetsGroup?
    
    private let kAssetsViewCellIdentifier = "AssetsViewCellIdentifier"
    
    private let kAssetsSupplementaryViewIdentifier = "AssetsSupplementaryViewIdentifier"
    
    private var isRetainImage: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  Single Mode
         */
        if choosePhotoModel == .singleModel {
            maximumNumberOfSelection = 1
        }
        
        // init Settings.
        initSettings()
        
        // Loading Data Assets.
        fetchData ()
        
    }
    
    @IBAction func closeAction(any: AnyObject) {
        delegate?.assetsPickerControllerDidCancel()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initSettings() {
        self.collctionView.allowsMultipleSelection = true
        self.collctionView.registerClass(AIAssetsViewCell.self, forCellWithReuseIdentifier: kAssetsViewCellIdentifier)
        self.collctionView.registerClass(AIAssetsFootViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: kAssetsSupplementaryViewIdentifier)
        let width = UIScreen.mainScreen().bounds.size.width/4 - 1.5
        layoutColl.itemSize = CGSizeMake(width, width)
        layoutColl.footerReferenceSize = CGSizeMake(0, 44)
        layoutColl.sectionInset            = UIEdgeInsetsMake(0.0, 0, 0, 0)
        layoutColl.minimumInteritemSpacing = 2.0
        layoutColl.minimumLineSpacing      = 2.0
    }
    
    func fetchData() {
        //Find the frist Photo Ablum
        weak var wf = self
        assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group, stop) in
            if group != nil {
                
                wf?.groups.addObject(group)
                wf?.assetsGroup = group
                
                group.enumerateAssetsUsingBlock({ (asset, idnex, complate) in
                    
                    if asset != nil {
                        wf?.assets.addObject(asset)
                        if let newAsset = (asset.valueForProperty(ALAssetPropertyType)) as? String {
                            if newAsset == ALAssetTypePhoto {
                                wf?.numberOfPhotos += 1
                            }
                            
                        
                        }
                    }
                })
                wf?.collctionView.reloadData()
                
            }
            }) { (error) in
        }
        
       
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       /*
        let item = self.collectionView(self.collctionView, numberOfItemsInSection: 0) - 1
        let lastItemIndex = NSIndexPath(forItem: item, inSection: 0)
        if lastItemIndex.row >= 0 {
            //self.collctionView.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        }*/
        
        
    }
    
    /// Action
    
    @IBAction func finishChooseAction(any: AnyObject) {
        weak var wf = self
        let newArray = NSMutableArray()
        self.collctionView.indexPathsForSelectedItems()?.forEach({ (indexPath) in
            newArray.addObject((wf?.assets.objectAtIndex(indexPath.row))!)
        })
        delegate?.assetsPickerController(self, didFinishPickingAssets: newArray)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func preViewAction(any: AnyObject) {
        if self.collctionView.indexPathsForSelectedItems()?.count > 0 {
            let prevc = AIAssetsReviewsController.initFromNib()
            let newArray = NSMutableArray()
            weak var wf = self
            self.collctionView.indexPathsForSelectedItems()?.forEach({ (indexPath) in
                newArray.addObject((wf?.assets.objectAtIndex(indexPath.row))!)
            })
            prevc.assets = newArray
            prevc.maximumNumberOfSelection = self.maximumNumberOfSelection
            prevc.delegate = self.delegate
            self.navigationController?.pushViewController(prevc, animated: true)
        } else {
            SVProgressHUD.showErrorWithStatus("没有选中图片")
        }
    }
    
    @IBAction func retainActino(any: AnyObject) {
        isRetainImage = !isRetainImage
        refershDataSize(self.collctionView.indexPathsForSelectedItems())
    }
    
    func takePhotoAction() {
        
        let imagePickVC = UIImagePickerController()
        imagePickVC.delegate = self
        imagePickVC.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickVC, animated: true, completion: nil)
        
    }
    
    func refershDataSize(indexPaths: NSArray?) {
        if isRetainImage {
            var size = 0
            weak var wf = self
            indexPaths?.forEach({ (index) in
                if let assetObj = wf?.assets.objectAtIndex(index.row) as? ALAsset {
                    let representation =  assetObj.defaultRepresentation()
                    let imageBuffer = UnsafeMutablePointer<UInt8>.alloc(Int(representation.size()))
                    let bufferSize = representation.getBytes(imageBuffer, fromOffset: Int64(0),
                        length: Int(representation.size()), error: nil)
                    let dataImageFull: NSData =  NSData(bytesNoCopy:imageBuffer, length:bufferSize, freeWhenDone:true)
                    size += dataImageFull.length
                }
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

extension AIAssetsPickerController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let CellIdentifier = self.kAssetsViewCellIdentifier
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as? AIAssetsViewCell
        
        if indexPath.row == 0 {
            //return camera.
            cell?.showCamera = true
        } else {
            cell?.showCamera = false
        }
        
        if let curretnAsset = assets.objectAtIndex(indexPath.row) as? ALAsset {
            cell?.bind(curretnAsset)
            cell?.model = self.choosePhotoModel
        }
        
        return cell ?? AIAssetsViewCell()
        
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let CellIdentifier = self.kAssetsSupplementaryViewIdentifier
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: CellIdentifier, forIndexPath: indexPath) as? AIAssetsFootViewCell
        cell?.setNumberOfPhotos(numberOfPhotos)
        return cell ?? UICollectionReusableView()
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let asset = self.assets.objectAtIndex(indexPath.row)
        return selectionFilter.evaluateWithObject(asset) && (collectionView.indexPathsForSelectedItems()?.count < maximumNumberOfSelection)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            takePhotoAction()
        } else {
            delegate?.assetsPickerController(self, didSelectItemAtIndexPath: indexPath)
            setTitleWithSelectedIndexPaths(collectionView.indexPathsForSelectedItems())
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0 {
            delegate?.assetsPickerController(self, didDeselectItemAtIndexPath: indexPath)
            setTitleWithSelectedIndexPaths(collectionView.indexPathsForSelectedItems())
        }
        
    }
    
    
    func setTitleWithSelectedIndexPaths(indexPaths: NSArray?) {
        
        if let indexPaths = indexPaths {
            
            refershDataSize(indexPaths)
            
            if indexPaths.count == 0 {
                // NONE
                numberButton.backgroundColor = UIColor(hexString: "868c90", alpha: 0.60)
                numberButton.enabled = false
                numberButton.setTitle("上传", forState: UIControlState.Normal)
            } else {
                numberButton.enabled = true
                numberButton.backgroundColor = UIColor(hexString: "0077CF")
                numberButton.setTitle("\(indexPaths.count)/\(maximumNumberOfSelection) 上传", forState: UIControlState.Normal)
            }
            
        }
    }
    
}

extension AIAssetsPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
		let image = info[UIImagePickerControllerOriginalImage]
		AILog(image)
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
		picker.dismissViewControllerAnimated(true, completion: nil)
	}
	
}
