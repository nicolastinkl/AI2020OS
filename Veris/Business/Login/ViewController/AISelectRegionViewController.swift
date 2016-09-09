//
//  AISelectRegionViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISelectRegionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    var delegate: AISelectRegionViewControllerDelegate?
    var model: [RegionModel]?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self

        self.setupLoginNavigationBar("Select Country")
        //修复navigationController侧滑关闭失效的问题
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    func loadData() {
        let model = [RegionModel(countryNumber: "+86", regionName: "Countries.China".localized), RegionModel(countryNumber: "+33", regionName: "Countries.France".localized),
                     RegionModel(countryNumber: "+49", regionName: "Countries.Germany".localized),
                     RegionModel(countryNumber: "+61", regionName: "Countries.Australia".localized),
                     RegionModel(countryNumber: "+36", regionName: "Countries.Hungary".localized),
                     RegionModel(countryNumber: "+81", regionName: "Countries.Japan".localized)]
        self.model = model
    }

    //MARK: - tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = model {
            return model.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RegionSelectTableViewCell", forIndexPath: indexPath) as UITableViewCell
        let regionModel = model![indexPath.row]
        cell.textLabel?.text = regionModel.countryNumber
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = LoginConstants.Fonts.promptLabel
        cell.detailTextLabel?.text = regionModel.regionName
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.font = LoginConstants.Fonts.promptLabel
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if let delegate = delegate {
                delegate.didSelectRegion(cell.detailTextLabel!.text!, countryNumber: cell.textLabel!.text!)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

}

protocol AISelectRegionViewControllerDelegate {

    func didSelectRegion(regionName: String, countryNumber: String)
}

struct RegionModel {
    var countryNumber: String
    var regionName: String

    init(countryNumber: String, regionName: String) {
        self.countryNumber = countryNumber
        self.regionName = regionName
    }
}
