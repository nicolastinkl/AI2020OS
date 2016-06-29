//
//  CompondServiceCommentViewController.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CompondServiceCommentViewController: AbsCommentViewController {

    var comments: [CommentTestModel]!
    private var currentOperateCell = -1

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

        comments = [CommentTestModel]()

        for _ in 0 ..< 30 {
            comments.append(CommentTestModel())
        }

        serviceTableView.registerNib(UINib(nibName: "ServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "SubServiceCell")
        serviceTableView.registerNib(UINib(nibName: "TopServiceCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "TopServiceCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func pohotImageButtonClicked(button: UIImageView, buttonParent: UIView) {
        super.pohotImageButtonClicked(button, buttonParent: buttonParent)

        if let cell = buttonParent as? ServiceCommentTableViewCell {
            recordCurrentOperateCell(cell)
        }
    }

    private func recordCurrentOperateCell(cell: UITableViewCell) {
        currentOperateCell = cell.tag
    }

    private func getCurrentOperateCell() -> ServiceCommentTableViewCell? {
        if currentOperateCell != -1 {
            return (serviceTableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentOperateCell, inSection: 0)) as! ServiceCommentTableViewCell)
        } else {
            return nil
        }
    }

    override func imagePicked(image: UIImage) {
        if let cell = getCurrentOperateCell() {

            let row = cell.tag

            comments[row].images.append(image)
            
            if let cell = serviceTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) as? ServiceCommentTableViewCell {
                cell.addImage(image)
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


        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("TopServiceCell") as!ServiceCommentTableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("SubServiceCell") as!ServiceCommentTableViewCell
        }

        cell.delegate = self
        cell.tag = indexPath.row

        resetCellUI(cell, indexPath: indexPath)

        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 270
    }

    private func resetCellUI(cell: ServiceCommentTableViewCell, indexPath: NSIndexPath) {
        cell.clearImages()
        
        cell.addImages(comments[indexPath.row].images)
    }
}

class CommentTestModel {
    var images = [UIImage]()
}
