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
    
    var chartBars: [UIView]!
    
    let colors = [
        UIColor(hexString: "#b32b1d"),
        UIColor(hexString: "#d05126"),
        UIColor(hexString: "#f79a00"),
        UIColor(hexString: "#619505"),
        UIColor(hexString: "#1c789f"),
        UIColor(hexString: "#7b3990"),
        ]
    let chartBarHeight: CGFloat = 80.displaySizeFrom1242DesignSize()
    let chartBarVSpace: CGFloat = 19.displaySizeFrom1242DesignSize()
    
    var titleLabel: UILabel!
    var dailyLabel: UILabel!
    var installed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupChartBars()
        setupTitleLabels()
    }
    
    func setupTitleLabels() {
        titleLabel = UILabel()
        titleLabel.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        titleLabel.textColor = UIColor.whiteColor()
        
        addSubview(titleLabel)
        
        dailyLabel = UILabel()
        dailyLabel.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        dailyLabel.textColor = UIColor(hexString: "#d8d6d6")
        addSubview(dailyLabel)
        
        
        
    }
    func setupChartBars() {
        var result = [UIView]()
        for i in 0...5 {
            // setup chart number label
            let label = UILabel()
            label.textColor = UIColor.whiteColor()
            
            // setup chart bar
            let chartBar = UIView()
            chartBar.backgroundColor = colors[i]
            
            // add to array
            result.append(chartBar)
            self.chartLabels.append(label)
            addSubview(chartBar)
            
            // setup view hirachy
            chartBar.addSubview(label)
            
            // setup autolayout
            label.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(chartBar)
                make.trailing.equalTo(chartBar).offset(-10)
            })
            
        }
        chartBars = result
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if installed == false {
            installed = true
            
            // setup titles constraints
            titleLabel.snp_makeConstraints { (make) in
                make.top.equalTo(self)
                make.leading.equalTo(42.displaySizeFrom1242DesignSize())
            }
            
            dailyLabel.snp_makeConstraints { (make) in
                make.bottom.equalTo(titleLabel)
                make.leading.equalTo(titleLabel.snp_trailing).offset(10.displaySizeFrom1242DesignSize())
            }
            
            // setup chartBars
            for (i, chartBar) in chartBars.enumerate() {
                chartBar.snp_makeConstraints(closure: { (make) in
                    make.top.equalTo(chartBarVSpace + CGFloat(i) * (chartBarVSpace+chartBarHeight))
                    make.height.equalTo(chartBarHeight)
                    make.leading.equalTo(42.displaySizeFrom1242DesignSize())
                    make.trailing.equalTo(self).offset(-42.displaySizeFrom1242DesignSize())
                    if i == chartBars.count - 1 {
                        make.bottom.equalTo(self)
                    }
                })
            }
        }
    }
    
    class func needsUpdateConstraints() -> Bool {
        return true
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
