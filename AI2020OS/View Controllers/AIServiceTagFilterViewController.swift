//
//  AIServiceTagFilterViewController.swift
//  AI2020OS
//
//  Created by admin on 15/6/9.
//  Copyright (c) 2015年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AIServiceTagFilterViewController: AITagFilterViewController {
    
    private var tags: [String]?
    private var manager: AIFavorServicesManager?
    
    
    override func viewDidLoad() {
        manager = AIMockFavorServicesManager()
        
        manager?.getServiceTags(loadTagData)
        
        super.viewDidLoad()
    }
    
    override func played() -> NSArray {
        if playe == nil {
            var playeCount = 1
            playe = NSMutableArray(capacity: playeCount)
            
            for var i = 0; i < playeCount; ++i {
                var play = Play()
                switch i {
                case 0:
                    play.name = "按标签筛选"
                    var quotations = NSMutableArray(capacity: tags!.count)
                    
                    for tag in tags! {
                        var dic = NSDictionary(object: tag, forKey: "tagName")
                        quotations.addObject(dic)
                    }
                    
                    play.quotations = quotations
                    playe!.addObject(play)
                default:
                    continue
                }
            }
    
        }
        
        return playe!
    }
    
    

    
    private func loadTagData(result: (model: [String], err: Error?)) {
        
        if result.err == nil {
            tags = result.model
        }
    }
}

extension AIServiceTagFilterViewController : DLHamburguerViewControllerDelegate {
    @objc func hamburguerViewController(hamburguerViewController: DLHamburguerViewController, willHideMenuViewController menuViewController: UIViewController) {
        println("willHideMenuViewController")
    }
}


