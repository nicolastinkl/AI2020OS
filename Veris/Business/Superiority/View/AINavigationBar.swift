//
//  AINavigationBar.swift
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


class AINavigationBar: UIView {

    var holderViewController: UIViewController?

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backButton.addTarget(self, action: #selector(AINavigationBar.closeViewController), forControlEvents: UIControlEvents.TouchUpInside)
    }

    func setRightIcon1Action(icon: UIImage){
        commentButton.setImage(icon, forState: UIControlState.Normal)
    }
    
    func setRightIcon2Action(icon: UIImage){
        videoButton.setImage(icon, forState: UIControlState.Normal)
    }

    func showNavigationLine() {

        Async.main(after: 0.1) {
            self.addBottomWholeSSBorderLine(AIApplication.AIColor.MainSystemLineColor)
        }
    }

    func closeViewController() {
        holderViewController?.dismissViewControllerAnimated(true, completion: nil)
        //AIApplication().SendAction("closeViewController", ownerName: self)
    }

}
