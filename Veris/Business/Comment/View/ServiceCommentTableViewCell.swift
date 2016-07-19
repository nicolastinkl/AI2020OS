//
//  ServiceCommentTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/6/3.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class ServiceCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imageButton: UIImageView!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceName: UILabel!

    @IBOutlet weak var starRateView: StarRateView!
    @IBOutlet weak var bottomStrokeLine: StrokeLineView!
    @IBOutlet weak var appendCommentButton: UIButton!
    @IBOutlet weak var firstComment: CommentAreaView!
    @IBOutlet weak var appendComment: CommentAreaView!
    @IBOutlet weak var appendCommentHeight: NSLayoutConstraint!
    @IBOutlet weak var imageButtonSpace: NSLayoutConstraint!
    @IBOutlet weak var appendCommentBottomMargin: NSLayoutConstraint!
    
    private var hasAppendHeight: CGFloat!
    private var commentAreaHeight: CGFloat!
    
    var delegate: CommentDistrictDelegate?
    
    private var appendCommentExpanded = false
    private var stateFactory = [CommentStateEnum: CommentState]()
    private var state: CommentState!
    
//    func setIsInAppendComment(isInAppendComment: Bool) {
//        if isInAppendComment != appendCommentExpanded {
//            appendCommentExpanded = isInAppendComment
//            
//            appendCommentAreaHidden(!isInAppendComment)
//            
//        }
//    }
    
    func getState() -> CommentState {
        return state
    }
    
    func resetState(state: CommentState) {
        if let s = self.state {
            if s.dynamicType != state.dynamicType {
                self.state = state
                self.state.updateUI()
            }
        }
    }
    
    func setModel(model: SubServiceCommentViewModel) -> CommentState {
        if model.commentEditable {
            return getState(.CommentEditable)
        } else {
            return getState(.CommentFinshed)
        }
    }
    
//    var isAppendCommendExpanded: Bool {
//        get {
//            return appendCommentExpanded
//        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        state = getState(.CommentEditable)
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .None

        serviceIcon.clipsToBounds = true

        serviceIcon.image = UIImage(named: "testHolder1")

        let imageSelector =
            #selector(ServiceCommentTableViewCell.imageButtonAction(_:))
        let imageTap = UITapGestureRecognizer(target: self, action: imageSelector)
        imageButton.addGestureRecognizer(imageTap)

        
        serviceName.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(48))
        firstComment.hint.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
        firstComment.inputTextView.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
        appendComment.inputTextView.font = AITools.myriadSemiCondensedWithSize(AITools.displaySizeFrom1242DesignSize(42))
        
        appendCommentButton.layer.cornerRadius = appendCommentButton.height / 2
        appendCommentButton.layer.borderWidth = 1
        appendCommentButton.layer.borderColor = UIColor(hex: "FFFFFFAA").CGColor
        
        hasAppendHeight = height
        commentAreaHeight = firstComment.height
    }

    override func layoutSubviews() {
        serviceIcon.layer.cornerRadius = serviceIcon.height / 2
    }
    
//    var isCommentDone: Bool = false {
//        willSet {
//            
//            if newValue != isCommentDone && newValue {
//                appendComment.finishComment()
//                
//                appendCommentBottomMargin.constant -= imageButtonSpace.constant
//                appendCommentButton.removeFromSuperview()
//                imageButton.removeFromSuperview()
//                
//                delegate?.commentHeightChanged?()
//            }
//            
//        }
//    }
    
//    var canAppendComment: Bool = true {
//        didSet {
//            if canAppendComment {
//                firstComment.finishComment()
//                appendCommentButton.hidden = false
//            }
//        }
//    }
    
    @IBAction func appendButtonAction(sender: UIButton) {
        resetState(getState(.AppendEditing))
        
        delegate?.appendCommentClicked(sender, buttonParentCell: self)
    }

    func imageButtonAction(sender: UIGestureRecognizer) {
        delegate?.photoImageButtonClicked(imageButton, buttonParentCell: self)
    }
    
    func addImage(image: UIImage) {
        if state is AppendEditingState {
            appendComment.imageCollection.addImage(image)
        } else {
            firstComment.imageCollection.addImage(image)
        }
    }
    
    func addImages(images: [UIImage]) {
        if state is AppendEditingState {
            appendComment.imageCollection.addImages(images)
        } else {
            firstComment.imageCollection.addImages(images)
        }
    }
    
    func clearImages() {
        appendComment.imageCollection.clearImages()
    }
    
    var hasAppendContent: Bool {
        get {
            let text = appendComment.inputTextView.text
            return (text != nil && !text!.isEmpty) || appendComment.imageCollection.images.count != 0
        }
    }
    
    private func appendCommentAreaHidden(hidden: Bool) {
        appendComment.hidden = hidden
        appendCommentButton.hidden = hidden
        bottomStrokeLine.hidden = !hidden
        
        if hidden {
            appendCommentHeight.constant = 0
        } else {
            appendCommentHeight.constant = firstComment.height
            
            Async.main(after: 0.1, block: { [weak self] in
                self?.appendComment.inputTextView.becomeFirstResponder()
            })
        }
              
    }
    
    private func getState(state: CommentStateEnum) -> CommentState {
        var s = stateFactory[state]
        
        if s == nil {
            switch state {
            case .CommentEditable:
                s = CommentEditableState(cell: self)
            case .CommentFinshed:
                s = CommentFinshedState(cell: self)
            case .AppendEditing:
                s = AppendEditingState(cell: self)
            case .AppendEdited:
                s = AppendEditedState(cell: self)
            case .Done:
                s = DoneState(cell: self)
            }
            
            stateFactory[state] = s
        }
        
        return s!
    }
}

extension ServiceCommentTableViewCell: CommentCellProtocol {
    func touchOut() {
        if state is AppendEditingState {
            if !hasAppendContent {
                state = getState(.CommentFinshed)
                state.updateUI()
            }
        }
    }
}

private enum CommentStateEnum {
    case CommentEditable
    case CommentFinshed
    case AppendEditing
    case AppendEdited
    case Done
}

protocol CommentState: class {
    func updateUI()
}

private class AbsCommentState: CommentState {
    
    var cell: ServiceCommentTableViewCell

    init(cell: ServiceCommentTableViewCell) {
        self.cell = cell
    }
    func updateUI() {
        
    }
}

// 评论可编辑
private class CommentEditableState: AbsCommentState {
    override func updateUI() {
        cell.appendCommentButton.hidden = true
    }
}

//class CommentedNoCommitState: AbsCommentState {
//    override func updateUI() {
//        
//    }
//}

// 已提交过评价
private class CommentFinshedState: AbsCommentState {
    override func updateUI() {
        cell.firstComment.finishComment()
        cell.appendCommentButton.hidden = false
        cell.imageButton.hidden = true
    }
}

// 编辑追加评价中。（展开追加评价）
private class AppendEditingState: AbsCommentState {
    override func updateUI() {
        cell.appendCommentHeight.constant = cell.firstComment.height
        cell.appendCommentButton.hidden = true
        cell.imageButton.hidden = false
        
        Async.main(after: 0.1, block: { [weak self] in
            self?.cell.appendComment.inputTextView.becomeFirstResponder()
            })
    }
}

// 追加评价已编辑，未提交
private class AppendEditedState: AbsCommentState {
    override func updateUI() {
        cell.appendCommentAreaHidden(false)
    }
}


// 评价和追加评价都已提交完成
private class DoneState: AbsCommentState {
    private var finished = false
    
    override func updateUI() {
        if finished {
            return
        }
        
        finished = true
        
        cell.appendComment.finishComment()
        
        cell.appendCommentBottomMargin.constant -= cell.imageButtonSpace.constant
        cell.appendCommentButton?.removeFromSuperview()
        cell.imageButton?.removeFromSuperview()
        
        cell.delegate?.commentHeightChanged?()
    }
}





