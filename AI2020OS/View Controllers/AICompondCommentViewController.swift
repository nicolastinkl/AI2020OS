//
//  AICompondCommentViewController.swift
//  AI2020OS
//
//  Created by Rocky on 15/8/21.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AICompondCommentViewController: UITableViewController {
    let CELL_TAG = 9
    private var commentModel: AIServiceCommentListModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        let commentManager = AIServiceCommentMockManager()
        commentManager.getCommentTags(1234, success: loadSeccess, fail: loadFail)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  
        return commentModel.service_comment_list!.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 110
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SingleCommentCell") as UITableViewCell
        
        var commentFrame = CGRect(x: 0, y: 0, width: tableView.width, height: 110)
        
        let commentView = AISingleCommentView.instance(self)
        commentView.frame = commentFrame
        commentView.tag = CELL_TAG
        cell.addSubview(commentView)
        commentView.commentData = commentModel.service_comment_list!.objectAtIndex(indexPath.row) as? AIServiceComment
        return cell
    }
    
    private func loadSeccess(responseData: AIServiceCommentListModel) {
        if responseData.service_comment_list != nil && responseData.service_comment_list!.count > 0 {
            commentModel = responseData
            self.tableView.reloadData()
         //   commentView.commentData = responseData.service_comment_list!.objectAtIndex(0) as? AIServiceComment
        }
    }
    
    private func loadFail(errType: AINetError, errDes: String) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

