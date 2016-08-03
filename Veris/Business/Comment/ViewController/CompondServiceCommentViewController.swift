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
    private var commentManager: CommentManager!

    @IBOutlet weak var serviceTableView: UITableView!
    @IBOutlet weak var checkbox: CheckboxButton!
    @IBOutlet weak var submit: UIButton!

    class func loadFromXib() -> CompondServiceCommentViewController {
        let vc = CompondServiceCommentViewController(nibName: "CompondServiceCommentViewController", bundle: nil)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentManager = DefaultCommentManager()

        checkbox.layer.cornerRadius = 4
        submit.layer.cornerRadius = submit.height / 2

        
        
        serviceTableView.rowHeight = UITableViewAutomaticDimension
        serviceTableView.estimatedRowHeight = 270

        serviceTableView.registerNib(UINib(nibName: "ServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServiceCell")
        serviceTableView.registerNib(UINib(nibName: "TopServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "TopServiceCell")
        
        loadServiceComments()
        loadAndMergeModelFromLocal()
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
        
        if !commentManager.isAllImagesUploaded() {
            AIAlertView().showInfo("正在上传图片，不能提交", subTitle: "正在上传图片，不能提交")
            return
        }
        
        var submitList = [ServiceComment]()
        
        for item in cellsMap {
            guard let cell = item.1 as? ServiceCommentTableViewCell else {
                continue
            }
            
            if let comment = cell.getSubmitData() {
                if !CommentUtils.isStarValueValid(comment.rating_level) {
                    AIAlertView().showInfo("评分不能为空，不能提交", subTitle: "评分不能为空，不能提交")
                    return
                } else {
                    submitList.append(comment)
                }
            }
        }
        
        if submitList.count == 0 {
            return
        }
        
        commentManager.submitComments("1", userType: 1, commentList: submitList, success: { (responseData) in
            if responseData.result {
                AIAlertView().showInfo("提交成功", subTitle: "提交成功")
            } else {
                AIAlertView().showInfo("提交失败", subTitle: "提交失败")
            }
            }) { (errType, errDes) in
                AIAlertView().showInfo("提交失败", subTitle: "提交失败")
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
    
    private func loadAndMergeModelFromLocal() {
        var serviceIds = [String]()
        
        for comment in comments {
            serviceIds.append(comment.serviceId)
        }
        
        
        if let localList = commentManager.loadCommentModelsFromLocal(serviceIds) {
            
            func findLocalModel(id: String) -> ServiceCommentLocalSavedModel? {
                for local in localList {
                    if local.serviceId == id {
                        return local
                    }
                }
                
                return nil
            }
            
            for comment in comments {
                if let model = findLocalModel(comment.serviceId) {
                    model.isAppend = !comment.commentEditable
                    comment.loaclModel = model
                }
            }
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
        
        let serviceId = comments[row].serviceId      
        
        for info in infos {
            if info.url == nil {
                saveImageToAlbum(serviceId, info: info)
            } else {
                commentManager.recordUploadImage(serviceId, imageId: createImageId(info), url: info.url!)
            }
        }
    }
    
    private func createImageId(info: ImageInfo) -> String {
        return info.url!.absoluteString
    }
    
    private func ensureLoaclSavedModelNotNil(index: Int) {
        if comments[index].loaclModel == nil {
            let model = ServiceCommentLocalSavedModel()
            
            comments[index].loaclModel = model
        }
    }
  
    func saveImageToAlbum(serviceId: String, info: ImageInfo) {
        guard let im = info.image else {
            return
        }
        
        ALAssetsLibrary().writeImageToSavedPhotosAlbum(im.CGImage, orientation: ALAssetOrientation(rawValue: im.imageOrientation.rawValue)!) {[weak self] (path: NSURL!, error: NSError!) in
            if path != nil {
                info.url = path
                
                if let s = self {
                    s.commentManager.recordUploadImage(serviceId, imageId: s.createImageId(info), url: info.url!)
                }
            }
        }
    }
    
    private func addImagesToCell(images: [ImageInfo], cell: ServiceCommentTableViewCell) {
        for imageInfo in images {
            if let im = imageInfo.image {
                cell.addAsyncUploadImage(im, id: createImageId(imageInfo), complate: { [weak self] (id, url, error) in
                    if let u = url {
                        self?.commentManager.notifyImageUploadResult(id!, url: u)
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
        
        // 不复用cell
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
     //   cell.clearImages()
        
        if let state = comments[indexPath.row].cellState {
       //     let urls = getImageUrls(indexPath.row)
      //      cell.addAsyncDownloadImages(urls)
            
            cell.resetState(state)
        }
    }
    
//    private func getImageUrls(row: Int) -> [NSURL] {
//        var urls = [NSURL]()
//        
//        if let ims = comments[row].loaclModel?.imageInfos {
//            for info in ims {
//                guard let u = info.url else {
//                    continue
//                }
//                
//                if info.isSuccessUploaded {
//                    urls.append(u)
//                }
//            }
//        }
//        
//        return urls
//    }
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
    var cellState: CommentStateEnum!
    var commentEditable = false
    // 是否是已经完成的评论
    var submitted = false
    var serviceId = ""
    var loaclModel: ServiceCommentLocalSavedModel?
    var firstComment: ServiceComment?
    var appendComment: ServiceComment?
}

protocol CommentCellProtocol {
    func touchOut()
}
