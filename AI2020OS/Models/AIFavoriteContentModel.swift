//
//  AIFavoriteContentModel.swift
//  AI2020OS
//
//  Created by tinkl on 10/6/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import JSONJoy

enum FavoriteTypeEnum: Int{
    case music  = 1
    case video  = 2
    case text  = 3
    case web   = 4
    
    func value() -> Int{
        switch self
        {
            case .music:
                return 1
            
            case .video:
                return 2
            
            case .text:
                return 3
            
            case .web:
                return 4
            
            default:
                break
        }
        return 0
    }
    
    
}

class AIFavoriteContentModel: JSONJoy {
 
    var favoriteTitle : String?
    var favoriteDes : String?
    var favoriteFromWhere : String?
    var favoriteFromWhereURL : String?
    var favoriteAvator : String?
    var favoriteCurrentTag : String?
    var favoriteType : Int?         //类型 (video txt music)
    var isFavorite : Int?
    var favoriteTags: Array<String>?
    var serverList: Array<AIServiceTopicModel>?
    var cellName:String = "MainCell"
    var isAttached:Bool = false
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder) {
        favoriteTitle = decoder["title"].string
        favoriteDes = decoder["des"].string
        favoriteFromWhere = decoder["from"].string
        favoriteAvator = decoder["avator"].string
        isFavorite = decoder["isfav"].integer
        favoriteType = decoder["type"].integer
        favoriteFromWhereURL = decoder["fromurl"].string
        decoder.getArray(&favoriteTags)
        
        if let sparam = decoder["service_param_list"].array {
            serverList = Array<AIServiceTopicModel>()
            for serviceParam in sparam {
                serverList?.append(AIServiceTopicModel(serviceParam))
            }
        }
    }

}