//
//  CapitalFlowViewController.swift
//  AIVeris
//
//  Created by Rocky on 2016/10/13.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class CapitalFlowViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        tableView.registerNib(UINib(nibName: "CapitalFlowCell", bundle: nil), forCellReuseIdentifier: "CapitalFlowCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 25

    }
    
    class func initFromStoryboard() -> CapitalFlowViewController {
        let vc = UIStoryboard(name: "CapitalFlow", bundle: nil).instantiateViewControllerWithIdentifier("CapitalFlowViewController") as! CapitalFlowViewController
        return vc
    }

    @IBAction func filteAction(sender: AnyObject) {
        
    }
    
    private func setupNavigationBar() {
        
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "comment-back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(UIViewController.dismiss), forControlEvents: .TouchUpInside)
        
        
        let appearance = UINavigationBarAppearance()
        appearance.leftBarButtonItems = [backButton]
        
        appearance.itemPositionForIndexAtPosition = { index, position in
            if position == .Left {
                return (47.displaySizeFrom1242DesignSize(), 55.displaySizeFrom1242DesignSize())
            } else {
                return (47.displaySizeFrom1242DesignSize(), 40.displaySizeFrom1242DesignSize())
            }
        }
        appearance.barOption = UINavigationBarAppearance.BarOption(backgroundColor: UIColor(hexString: "#0f0c2c"), backgroundImage: nil, removeShadowImage: true, height: AITools.displaySizeFrom1242DesignSize(192))
        appearance.titleOption = UINavigationBarAppearance.TitleOption(bottomPadding: 51.displaySizeFrom1242DesignSize(), font: AITools.myriadSemiCondensedWithSize(72.displaySizeFrom1242DesignSize()), textColor: UIColor.whiteColor(), text: "CapitalFlowViewController.title".localized)
        setNavigationBarAppearance(navigationBarAppearance: appearance)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CapitalFlowViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CapitalFlowCell") as! CapitalFlowCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
}
