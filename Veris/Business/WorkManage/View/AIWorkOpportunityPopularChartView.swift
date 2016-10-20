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
    var chartBars: [AIWorkOpportunityPopularChartBarView] = []
    
    let colors = [
        UIColor(hexString: "#b32b1d"),
        UIColor(hexString: "#d05126"),
        UIColor(hexString: "#f79a00"),
        UIColor(hexString: "#619505"),
        UIColor(hexString: "#1c789f"),
        UIColor(hexString: "#7b3990"),
        ]
    
    var services = [AISearchServiceModel]()

    let longest = 919.displaySizeFrom1242DesignSize()
    let shortest = 259.displaySizeFrom1242DesignSize()
    let diff = 660.displaySizeFrom1242DesignSize()
    
    let chartBarHeight: CGFloat = 80.displaySizeFrom1242DesignSize()
    let chartBarVSpace: CGFloat = 19.displaySizeFrom1242DesignSize()
    
    var titleLabel: UILabel!
    var dailyLabel: UILabel!
    var installed = false
    
    convenience init(services: [AISearchServiceModel]) {
        self.init(frame: .zero)
        self.services = services
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        fullfillServices()
        setupChartBars()
        setupTitleLabels()
    }
    
    func fullfillServices() {
        // 后台返回数据不够6个
        if services.count < 6 {
            var copy = [AISearchServiceModel]()
            while copy.count < 6 {
                if let service = services.first {
                    let s = AISearchServiceModel()
                    s.name = service.name
                    s.sid = service.sid
                    s.order_time = service.order_time
                    s.desc = service.desc
                    copy.append(s)
                }
            }
            let fakeNumbers = [
            26438,
            15400,
            10389,
            6519,
            5219,
            2167
                ]
            for (i, service) in copy.enumerate() {
                service.order_time = String(format: "%d", fakeNumbers[i])
            }
            services = copy
        }
    }
    
    func setupTitleLabels() {
        titleLabel = UILabel()
        titleLabel.font = AITools.myriadSemiCondensedWithSize(60.displaySizeFrom1242DesignSize())
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = "What's Popular"
        
        addSubview(titleLabel)
        
        dailyLabel = UILabel()
        dailyLabel.font = AITools.myriadSemiCondensedWithSize(25.displaySizeFrom1242DesignSize())
        dailyLabel.textColor = UIColor(hexString: "#d8d6d6")
        dailyLabel.text = "Daily"
        addSubview(dailyLabel)
    }
    
    func setupChartBars() {
        // setup chart bars
        services = services.sort({ (a, b) -> Bool in
            return a.order_time.toInt()! > b.order_time.toInt()!
        })
        
        let unitLength = diff / CGFloat(services.first!.order_time.toInt()! - services.last!.order_time.toInt()!)
        
        for i in 0...5 {
            let service = services[i]
            var length = unitLength * CGFloat(service.order_time.toInt()!) + shortest
            if i == 0 {
                length = longest
            } else if i == 5 {
                length = shortest
            }
            let numberText = String(format: "%@ Orders", service.order_time)
            let chartBar = AIWorkOpportunityPopularChartBarView(color: colors[i], name: service.name, numberText: numberText, barLength: length)
            chartBars.append(chartBar)
            addSubview(chartBar)
        }
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
                make.baseline.equalTo(titleLabel)
                make.leading.equalTo(titleLabel.snp_trailing).offset(10.displaySizeFrom1242DesignSize())
            }
            
            // setup chartBars
            for (i, chartBar) in chartBars.enumerate() {
                chartBar.snp_makeConstraints(closure: { (make) in
                    make.top.equalTo(titleLabel.snp_bottom).offset(chartBarVSpace + CGFloat(i) * (chartBarVSpace+chartBarHeight))
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
    
    var barLength: CGFloat = 0
    var numberLabel: UILabel!
    var nameLabel: UILabel!
    var bar: UIView!
    
    init(color: UIColor, name: String, numberText: String, barLength: CGFloat) {
        self.color = color
        self.name = name
        self.numberText = numberText
        self.barLength = barLength
        super.init(frame: .zero)
        setup()
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        bar.backgroundColor = color
        numberLabel.text = numberText
        nameLabel.text = name
    }
    func setup() {
        // setup bar
        bar = UIView()
        addSubview(bar)
        
        // setup numer label inside bar
        numberLabel = UILabel()
        numberLabel.font = AITools.myriadLightSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
        numberLabel.textColor = UIColor.whiteColor()
        addSubview(numberLabel)
        
        // setup name label
        nameLabel = UILabel()
        nameLabel.font = AITools.myriadSemiCondensedWithSize(42.displaySizeFrom1242DesignSize())
        nameLabel.textColor = UIColor.whiteColor()
        addSubview(nameLabel)
        
        
        // setup constraints
        bar.snp_makeConstraints { (make) in
            make.top.height.leading.equalTo(self)
            make.width.equalTo(barLength)
        }
        
        numberLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.trailing.equalTo(bar).offset(-15.displaySizeFrom1242DesignSize())
        }
        
        nameLabel.snp_makeConstraints { (make) in
            make.leading.equalTo(bar.snp_trailing).offset(20.displaySizeFrom1242DesignSize())
            make.centerY.equalTo(self)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
    }
}
