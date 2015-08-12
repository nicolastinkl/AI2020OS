//
//  AIHttpEngine.swift
//  AI2020OS
//
//  Created by tinkl on 2/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation
import Alamofire
import JSONJoy

struct Error {
    let message : String
    let code : Int
}


/*!
 *  @author tinkl, 15-04-02 15:04:53
 *
 *  AI2020OS 网络引擎
 */
struct AIHttpEngine{
    
    private static let baseURL = "http://171.221.254.231:8282"
    private static let clientID = "750ab22aac78be1c0a1a6d"
    private static let clientSecret = "53e3822c41c5bf26d0ef982693f215c72d87da"

    // MARK ResourcePath With domain
    enum ResourcePath: Printable {
        case GetServicesTopic
        case GetServiceDetail
        case CommentUpvote(commentId: Int)
        case CommentReply(commentId: Int)
        //add by liux 查询订单列表
        case GetOrderList
        // 查询订单详情
        case GetOrderDetail
        // 查询热门搜索
        case QueryHotSearch
        // 按服务目录查询服务
        case QueryServiceItemsByCatalogId
        // 获取所有的服务类
        case GetAllServiceCatalog
        // 获取收藏的服务
        case QueryCollectedServices
        // 获取收藏服务所有标签
        case QueryServiceTags
        // 获取收藏内容列表
        case QueryCollectedContents
        // 删除收藏内容
        case DelContentFromFavorite
        // 修改收藏内容星表
        case ModifyFavoriteFlag
        // 提交订单
        case SubmitOrder

        var description: String {
            switch self {
            case .GetServiceDetail: return "/sboss/getServiceDetail"
            case .GetServicesTopic: return "/sboss/getServiceTopic"
            case .GetOrderList: return "/sboss/queryOrderList"
            case .GetOrderDetail: return "/sboss/queryOrderDetail"
            case .QueryHotSearch: return "/sboss/queryHotSearch"
            case .QueryServiceItemsByCatalogId: return "/sboss/getService"
            case .GetAllServiceCatalog: return "/sboss/getAllServiceCatalog"
            case .QueryCollectedServices: return "/sboss/queryCollectedServices"
            case .QueryServiceTags: return "/sboss/queryServiceTags"
            case .QueryCollectedContents: return "/sboss/queryCollectedContents"
            case .DelContentFromFavorite: return "/sboss/delContentFromFavorite"
            case .ModifyFavoriteFlag: return "/sboss/modifyFavoriteFlag"
            case .SubmitOrder: return "/sboss/submitOrder"
            case .CommentUpvote(let id): return "/api/v1/comments/\(id)/upvote"
            case .CommentReply(let id): return "/api/v1/comments/\(id)/reply"
            }
        }
    }
    
    static func postRequestWithParameters(path:ResourcePath,parameters: [String: AnyObject]? = nil,response: (response:AnyObject?,error:Error?) -> ()) {
        
        // Create manager
        var manager = Manager.sharedInstance
        
        // Add Headers
        manager.session.configuration.HTTPAdditionalHeaders = ["HttpQuery":"0&0&0&0"]
        
        let paras: [String: AnyObject]? = [
            "data":parameters!,
            "desc":[
                "data_mode": 0,
                "digest": ""
            ]
        ]
        
        println("url: \(self.baseURL+path.description)      ------------   parameters:\(parameters)")

        // Create manager
        var manager = Manager.sharedInstance
        
        // Add Headers
        manager.session.configuration.HTTPAdditionalHeaders = ["HttpQuery":"0&0&100000001872&0"]

        // Send Reqeust...
        let encoding = Alamofire.ParameterEncoding.JSON
        Alamofire.request(.POST, self.baseURL+path.description,parameters:paras, encoding: encoding)
            .responseJSON { (_,_,JSON,error) in
                
                func fail(){
                    response(response: nil, error: Error(message: "Error", code: 0))
                }
                
                if let reponsess = JSON as? NSDictionary {
                    if let descValue = reponsess["desc"] as? NSDictionary{
                        let stas: AnyObject = descValue["result_code"]!

                        if let dataValue = reponsess["data"] as? NSDictionary{
                            println(dataValue)
                            response(response: dataValue, error: nil)
                        }
                        if let dataValue = reponsess["data"] as? NSArray{
                            println(dataValue)
                            response(response: dataValue, error: nil)
                        }
                        
                    }
                }
                if let eror = error{
                    fail()
                }
                
        }
    }
    
    static func moviesForSection(response: ([Movie]) -> ()) {
        Alamofire.request(.GET, "http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&sort_by=popularity.desc")
            .responseJSON { (_,_,JSON,_) in
                if let reponsess: AnyObject = JSON{
                    var httpreponse = MovieReponse(JSON as NSDictionary)
                    response(httpreponse.results!)
                }else{
                    response([])
                }
        }
    }

    static func kmdetailsForMoive(movieId:String,response: (AIKMMovie) -> ()) {
        Alamofire.request(.GET, "http://api.themoviedb.org/3/movie/"+movieId+"?api_key=328c283cd27bd1877d9080ccb1604c91")
            .responseJSON { (_,_,JSON,_) in
                if let reponsess: AnyObject = JSON{
                    var httpreponse = AIKMMovie(JSON as NSDictionary)                    
                    response(httpreponse)
                }else{
                    response(AIKMMovie())
                }
        }
    }    
    
    static func weatherForLocation(response: (WeatherModel) -> ()) {
        Alamofire.request(.GET, "http://www.weather.com.cn/adat/sk/101010100.html")
            .responseJSON { (_,_,JSON,_) in
                if let reponsess: AnyObject = JSON{
                    var httpreponse = WeatherModel(JSON as NSDictionary)
                    response(httpreponse ?? WeatherModel())
                }else{
                    response(WeatherModel())
                }
        }
        
    }
    
    // add by liliang: for text
    static func postWithParameters(path:ResourcePath,parameters: [String: AnyObject]? = nil, responseHandler: (response:AnyObject?, error:Error?) -> ()) {
        println("url: \(self.baseURL+path.description)      ------------   parameters:\(parameters)")
        let encoding = Alamofire.ParameterEncoding.JSON
        Alamofire.request(.POST, self.baseURL+path.description,parameters:parameters, encoding: encoding)
            .responseJSON { (_request, _response, JSON, error) in
                
                func fail(){
                    responseHandler(response: nil, error: Error(message: "Error", code: 0))
                }
                
                var result = false
                println("response: \(_response)")
                println("JSON: \(JSON)")
                
                if let reponses = JSON as? NSDictionary {
                    if let dataValue = reponses["data"] as? NSDictionary{
                  //      println(dataValue)
                        result = true
                        responseHandler(response: dataValue, error: nil)
                    }
                }
                
                if (error != nil) {
                    result = false
                }
                
                if !result {
                    fail()
                }
                
        }
    }
    
    
}
 