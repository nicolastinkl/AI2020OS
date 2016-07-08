//
//  SwitchedTableViewCell.swift
//  AIVeris
//
//  Created by Rocky on 16/7/4.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class SwitchedTableViewCell: UITableViewCell {

    private var viewsMap = [String: UIView]()
    private static let radius = 10
    
    var isTopRoundCorner = false
    var isBottomRoundCorner = false
    
    func getView(key: String) -> UIView? {
        let v = viewsMap[key]
        
        if v != nil {
            return v
        } else {
            return nil
        }
    }
    
    var mainView: UIView? {
        didSet {
            if let main = mainView {
                replaceContentView(main)
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        if isTopRoundCorner && isBottomRoundCorner {
            setCorner(corners: [.TopLeft, .TopRight, .BottomLeft, .BottomRight], cornerRadii: CGSize(width: SwitchedTableViewCell.radius, height: SwitchedTableViewCell.radius))
        } else if isTopRoundCorner {
            setCorner(corners: [.TopLeft, .TopRight], cornerRadii: CGSize(width: SwitchedTableViewCell.radius, height: SwitchedTableViewCell.radius))
        } else {
            setCorner(corners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: SwitchedTableViewCell.radius, height: SwitchedTableViewCell.radius))
        }       
    }
    
    func addCandidateView(viewKey: String, subView: UIView) {
        viewsMap[viewKey] = subView
    }
    
    func showView(viewKey: String) {
        if let v = viewsMap[viewKey] {
            replaceContentView(v)
        }
    }
    
    func showMainView() {
        if let main = mainView {
            replaceContentView(main)
        }
    }
    
    private func replaceContentView(view: UIView) {
        for subView in contentView.subviews {
            subView.removeFromSuperview()
        }
        
        contentView.addSubview(view)
        view.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
    }

}
