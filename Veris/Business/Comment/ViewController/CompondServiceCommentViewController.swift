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
    var comments: [SubServiceCommentViewModel]!
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

        comments = [SubServiceCommentViewModel]()

        for i in 0 ..< 5 {
            let model = SubServiceCommentViewModel()
            model.commentEditable = i % 2 != 0
            comments.append(model)
        }
        
        serviceTableView.rowHeight = UITableViewAutomaticDimension
        serviceTableView.estimatedRowHeight = 270

        serviceTableView.registerNib(UINib(nibName: "ServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServiceCell")
        serviceTableView.registerNib(UINib(nibName: "TopServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "TopServiceCell")
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
        for comment in comments {
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
        view.showLoading()
        
        let ser = HttpCommentService()
        
        ser.getCompondComment(serviceID, success: { (responseData) in
            self.view.hideLoading()
            let re = responseData
            print("getCompondComment success:\(re)")

        }) { (errType, errDes) in
            
            self.view.hideLoading()
            
            AIAlertView().showError("AIErrorRetryView.loading".localized, subTitle: "")
        }
    }

    override func imagePicked(image: UIImage) {
        if let cell = getCurrentOperateCell() {

            let row = cell.tag
            
            if let cell = serviceTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? ServiceCommentTableViewCell {
                if cell.isEditingAppendComment {
                    comments[row].secondImages.append(image)
                } else {
                    comments[row].firstImages.append(image)
                }
                
                cell.addAsyncUploadImage(image, id: nil, complate: nil)
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
        
    //    cell.addImages(comments[indexPath.row].images)
        
        if let state = comments[indexPath.row].cellState {
            cell.resetState(state)
        }
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

class SubServiceCommentViewModel {
    var firstImages = [UIImage]()
    var secondImages = [UIImage]()
    var cellState: CommentState!
    var commentEditable = false
}

protocol CommentCellProtocol {
    func touchOut()
}
