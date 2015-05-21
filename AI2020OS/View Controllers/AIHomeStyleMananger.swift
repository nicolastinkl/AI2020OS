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

    func fillDataWithModel(model:Movie){
        
        let idmov:Int? = model.id
        let movieid:String = String(idmov!)
        self.contentImage.assemblyID = movieid
        
        self.title.text = model.original_title
        self.contentImage.setURL(model.backdrop_path?.toURL(), placeholderImage:UIImage(named: "Placeholder"))

        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector("targetImageClickAction"))
        self.contentImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func targetImageClickAction(){
        AIApplication().SendAction("targetForServicesAction:", ownerName: self.contentImage)
    }
}

extension AIHomeViewStyleTitleAndContentView{
    func fillDataWithModel(model:Movie){
        let idmov:Int? = model.id
        let movieid:String = String(idmov!)
        self.contentImage.assemblyID = movieid
        
        self.title.text = model.original_title
        self.price.text = model.title
        self.contentImage.setURL(model.backdrop_path?.toURL(), placeholderImage:UIImage(named: "Placeholder"))

        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector("targetImageClickAction"))
        self.contentImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func targetImageClickAction(){
        AIApplication().SendAction("targetForServicesAction:", ownerName: self.contentImage)
    }
}

extension AIHomeViewStyleMultiepleView{
    func fillDataWithModel(model:Movie){
        let idmov:Int? = model.id
        let movieid:String = String(idmov!)
        self.contentImage.assemblyID = movieid
        
        self.title.text = model.original_title
        self.contentImage.setURL(model.backdrop_path?.toURL(), placeholderImage:UIImage(named: "Placeholder"))
        self.price.text = model.title
        self.nick.text = model.title
        self.avator.setImageURL(model.backdrop_path?.toURL(), placeholderImage: UIImage(named: "Placeholder"), forState: UIControlState.Normal)
        
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: Selector("targetImageClickAction"))
        self.contentImage.addGestureRecognizer(gestureRecognizer)
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