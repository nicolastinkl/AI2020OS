//
//  CompondServiceCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit
import AIAlertView

class CompondServiceCommentViewController: AbsCommentViewController {

    var serviceID: String!
    var comments: [ServiceCommentViewModel]!
    private var currentOperateCell = -1
    private var cellsMap = [Int: UITableViewCell]()

    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var checkbox: CheckboxButton!
    @IBOutlet weak var submit: UIButton!

    class func loadFromXib() -> CompondServiceCommentViewController {
        let vc = CompondServiceCommentViewController(nibName: "CompondServiceCommentViewController", bundle: nil)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        checkbox.layer.cornerRadius = 4
        submit.layer.cornerRadius = submit.height / 2

        
        
        serviceTableView.rowHeight = UITableViewAutomaticDimension
        serviceTableView.estimatedRowHeight = 270

        serviceTableView.registerNib(UINib(nibName: "ServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServiceCell")
        serviceTableView.registerNib(UINib(nibName: "TopServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "TopServiceCell")
        
        loadServiceComments()
        loadModelFromLocal()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        
        if let cell = getCurrentOperateCell() {
            cell.touchOut()
            comments[currentOperateCell].cellState = cell.getState()
        }
    }

    override func photoImageButtonClicked(button: UIImageView, buttonParentCell: UIView) {
        super.photoImageButtonClicked(button, buttonParentCell: buttonParentCell)

        if let cell = buttonParentCell as? ServiceCommentTableViewCell {
            recordCurrentOperateCell(cell)
        }
    }


    @IBAction func submitComments(sender: UIButton) {
        for _ in comments {
     //       comment.isCommentDone = true
        }
        
        serviceTableView.reloadData()
    }
    
    private func recordCurrentOperateCell(cell: UITableViewCell) {
        currentOperateCell = cell.tag
    }

    private func getCurrentOperateCell() -> ServiceCommentTableViewCell? {
        if currentOperateCell != -1 {
            return (serviceTableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentOperateCell, inSection: 0)) as? ServiceCommentTableViewCell)
        } else {
            return nil
        }
    }
    
    private func loadServiceComments() {
        comments = [ServiceCommentViewModel]()
        
        for i in 0 ..< 1 {
            let model = ServiceCommentViewModel()
            model.commentEditable = i % 2 != 1
            comments.append(model)
        }
        
//        view.showLoading()

        
//        let ser = HttpCommentService()
//        
//        ser.getCompondComment(serviceID, success: { (responseData) in
//            self.view.hideLoading()
//            let re = responseData
//            print("getCompondComment success:\(re)")
//
//        }) { (errType, errDes) in
//            
//            self.view.hideLoading()
//            
//            AIAlertView().showError("AIErrorRetryView.loading".localized, subTitle: "")
//        }
    }
    
    private func loadModelFromLocal() {
        for comment in comments {
            let model = CommentUtils.getCommentModelFromLocal(comment.serviceId)
            comment.loaclModel = model
        }
    }

    override func imagesPicked(images: [ImageInfo]) {
        if let cell = getCurrentOperateCell() {

            let row = cell.tag
            
            guard let cell = serviceTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? ServiceCommentTableViewCell else {
                return
            }
            
            recordImagesInfoToDataSource(images, cell: cell)
            
            addImagesToCell(images, cell: cell)
        }
    }
    
    private func recordImagesInfoToDataSource(infos: [ImageInfo], cell: ServiceCommentTableViewCell) {
        let row = cell.tag
        
        ensureLoaclSavedModelNotNil(row)
        
        comments[row].loaclModel!.images.appendContentsOf(infos)
        comments[row].loaclModel!.isAppend = cell.isEditingAppendComment
        comments[row].loaclModel!.changed = true
        
        for info in infos {
            if info.url == nil {
                saveImageToAlbum(info)
            }
        }
    }
    
    private func ensureLoaclSavedModelNotNil(index: Int) {
        if comments[index].loaclModel == nil {
            let model = ServiceCommentLocalSavedModel()
            model.images = [ImageInfo]()
            
            comments[index].loaclModel = model
        }
    }
  
    func saveImageToAlbum(info: ImageInfo) {
        guard let im = info.image else {
            return
        }
        
        ALAssetsLibrary().writeImageToSavedPhotosAlbum(im.CGImage, orientation: ALAssetOrientation(rawValue: im.imageOrientation.rawValue)!) { (path: NSURL!, error: NSError!) in
     //       info.url = path
        }
    }
    
    private func addImagesToCell(images: [ImageInfo], cell: ServiceCommentTableViewCell) {
        let row = cell.tag
        let serviceId = comments[row].serviceId
        let model = comments[row].loaclModel
        
        for imageInfo in images {
            if let im = imageInfo.image {
                cell.addAsyncUploadImage(im, id: nil, complate: { (id, url, error) in
                    if let u = url {
                        imageInfo.url = u
                        imageInfo.isUploaded = true
                        
                        if let m = model {
                            CommentUtils.saveCommentModelToLocal(serviceId, model: m)
                        }
                    }  
                })
            }
        }
    }
}

extension CompondServiceCommentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: ServiceCommentTableViewCell!
        
        if let c = cellsMap[indexPath.row] {
            return c
        }

        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("TopServiceCell") as!ServiceCommentTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SubServiceCell") as!ServiceCommentTableViewCell
        }

        cell.delegate = self
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        if comments[indexPath.row].cellState == nil {
            comments[indexPath.row].cellState = cell.setModel(comments[indexPath.row])     
        }

        resetCellUI(cell, indexPath: indexPath)
        
        cellsMap[indexPath.row] = cell

        return cell
    }
    

    private func resetCellUI(cell: ServiceCommentTableViewCell, indexPath: NSIndexPath) {
        cell.clearImages()
        
        if let state = comments[indexPath.row].cellState {
            if let urls = getImageUrls(indexPath.row) {
                cell.addAsyncDownloadImages(urls)
            }
            cell.resetState(state)
        }
    }
    
    private func getImageUrls(row: Int) -> [NSURL]? {
        if let ims = comments[row].loaclModel?.images {
            var urls = [NSURL]()
            for info in ims {
                if let u = info.url {
                    urls.append(u)
                }
                
            }
            
            return urls
        }
        
        return nil
    }
}

extension CompondServiceCommentViewController: CommentCellDelegate {
    func appendCommentClicked(clickedButton: UIButton, buttonParentCell: UIView) {
        if let cell = buttonParentCell as? ServiceCommentTableViewCell {
            currentOperateCell = cell.tag
            comments[currentOperateCell].cellState = cell.getState()
            serviceTableView.reloadData()
        }
    }
    
    func commentHeightChanged() {
        serviceTableView.reloadData()
    }
}

class ServiceCommentViewModel {
    var cellState: CommentState!
    var commentEditable = false
    var submitted = false
    var serviceId = ""
    var loaclModel: ServiceCommentLocalSavedModel?
    var firstComment: ServiceComment?
    var appendComment: ServiceComment?
}

protocol CommentCellProtocol {
    func touchOut()
}
