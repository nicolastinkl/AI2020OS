//
//  AIHomeStyleTopWithCustomView.swift
//  AI2020OS
//
//  Created by tinkl on 21/5/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

enum AIHomeCellViewStyle: Int{
    case ViewStyleTitle = 1
    case ViewStyleTitleAndContent = 2
    case ViewStyleMultiple = 3
    case ViewStyleMultipleWithList = 4
}

extension AIHomeViewStyleTitleView{

    func fillDataWithModel(model:AIServiceTopicModel){
        
        let idmov:Int? = model.service_id
        let movieid:String = String(idmov!)
        self.contentImage.assemblyID = movieid
        
        self.title.text = model.service_name
        self.contentImage.setURL(model.service_intro_url?.toURL(), placeholderImage:UIImage(named: "Placeholder"))

        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector("targetImageClickAction"))
        self.contentImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func targetImageClickAction(){
        AIApplication().SendAction("targetForServicesAction:", ownerName: self.contentImage)
    }
}

extension AIHomeViewStyleTitleAndContentView{
    func fillDataWithModel(model:AIServiceTopicModel){
        let idmov:Int? = model.service_id
        let movieid:String = String(idmov!)
        self.contentImage.assemblyID = movieid
        
        self.title.text = model.service_name
        self.price.text = model.service_price
        self.contentImage.setURL(model.service_intro_url?.toURL(), placeholderImage:UIImage(named: "Placeholder"))

        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector("targetImageClickAction"))
        self.contentImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func targetImageClickAction(){
        AIApplication().SendAction("targetForServicesAction:", ownerName: self.contentImage)
    }
    
}

extension AIHomeViewStyleMultiepleView{
    
    func fillDataWithModel(model:AIServiceTopicModel){
        
        if let idmov = model.service_id {
            self.contentImage.assemblyID = "\(idmov)"
            self.title.text = model.service_name
            self.contentImage.setURL(model.service_intro_url?.toURL(), placeholderImage:UIImage(named: "Placeholder"))
            self.price.text = model.service_price
            self.nick.text = model.provider_name
            self.avator.setImageURL(model.provider_portrait_url?.toURL(), placeholderImage: UIImage(named: "Placeholder"), forState: UIControlState.Normal)
            
            let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector("targetImageClickAction"))
            self.contentImage.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func targetImageClickAction(){
        AIApplication().SendAction("targetForServicesAction:", ownerName: self.contentImage)
    }
}

class AIHomeStyleMananger: NSObject {
    
    class func viewWithType(type:AIHomeCellViewStyle) -> UIView{
        switch type{
            case .ViewStyleTitle:
                let view = AIHomeViewStyleTitleView.currentView()
                return view
            
            case .ViewStyleTitleAndContent:
                let view = AIHomeViewStyleTitleAndContentView.currentView()
                return view
            
            case .ViewStyleMultiple:
                let view = AIHomeViewStyleMultiepleView.currentView()
                return view
            
            case .ViewStyleMultipleWithList:
                let view = AIHomeViewStyleMultiepleView.currentView()
                return view
            default:
               return  AIHomeViewStyleTitleView.currentView()
        }
    }
    
}