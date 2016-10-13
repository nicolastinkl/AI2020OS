//
//  AIWorkOpportunityPopularChartView.swift
//  AIVeris
//
//  Created by zx on 10/13/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIWorkOpportunityPopularChartView: UIView {
    
    var opportunities: [String]? = nil
    var chartLabels = [UILabel]()
    
    
    lazy var l: UILabel = { [unowned self] in
        let result = UILabel()
        return result
        }()
    
    
    
    
    lazy var chartBars: [UIView] = { [unowned self] in
        var result = [UIView]()
        for i in 0...5 {
            // setup chart number label
            let label = UILabel()
            label.textColor = UIColor.whiteColor()
            
            // setup chart bar
            let view = UIView()
            view.backgroundColor = colors[i]
            
            // add to array
            result.append(view)
            self.chartLabels.append(label)
            
            // setup view hirachy
            view.addSubview(label)
            
            // setup autolayout
            label.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(view)
                make.trailing.equalTo(view).offset(-10)
            })
            
        }
        return result
    }()
    
    static let colors = [
        UIColor(hexString: "#b32b1d"),
        UIColor(hexString: "#d05126"),
        UIColor(hexString: "#f79a00"),
        UIColor(hexString: "#619505"),
        UIColor(hexString: "#1c789f"),
        UIColor(hexString: "#7b3990"),
    ]
    
    var titleLabel = UILabel()
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class AIWorkOpportunityPopularChartBarView: UIView {
    
    var numberText: String?
    var name: String?
    var color: UIColor?
    var lenghtPercent: CGFloat = 0
    
    private lazy var numberLabel: UILabel = { [unowned self] in
        let result = UILabel()
        result.textColor = UIColor.whiteColor()
        self.addSubview(result)
        return result
        }()
    private lazy var nameLabel: UILabel = { [unowned self] in
        let result = UILabel()
        result.textColor = UIColor.whiteColor()
        self.addSubview(result)
        return result
        }()
    
    private lazy var bar: UIView = { [unowned self] in
        let result = UIView()
        self.addSubview(result)
        return result
        }()
    
    override func updateConstraints() {
        super.updateConstraints()
    }
}
