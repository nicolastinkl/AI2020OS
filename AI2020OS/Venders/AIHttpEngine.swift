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
    
    
    private static let baseURL = "https://api.asiainfo.com"
    private static let clientID = "750ab22aac78be1c0a1a6d"
    private static let clientSecret = "53e3822c41c5bf26d0ef982693f215c72d87da"

    // MARK ResourcePath With domain
    private enum ResourcePath: Printable {
        case Login
        case Stories
        case CommentUpvote(commentId: Int)
        case CommentReply(commentId: Int)

        var description: String {
            switch self {
            case .Login: return "/oauth/token"
            case .Stories: return "/api/v1/stories"
            case .CommentUpvote(let id): return "/api/v1/comments/\(id)/upvote"
            case .CommentReply(let id): return "/api/v1/comments/\(id)/reply"
            }
        }
    }
    
    private static func postRequestWithParameters(path:ResourcePath,response: (response:AnyObject?,error:Error?) -> ()) {
        Alamofire.request(.POST, self.baseURL+path.description)
            .responseJSON { (_,_,JSON,_) in
                if let reponsess: AnyObject = JSON{
                    var httpreponse = JSON as NSDictionary
                    let statusCode = httpreponse["responseCode"] as? Int
                    if statusCode == 200  {
                        response(response: httpreponse, error: nil)
                    }
                }else{
                    response(response: nil, error:  Error(message: "Something went wrong", code: 0))
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
        Alamofire.request(.GET, "http://m.weather.com.cn/data/101010100.html")
            .responseJSON { (_,_,JSON,_) in
                if let reponsess: AnyObject = JSON{
                    var httpreponse = WeatherModel(JSON as NSDictionary)
                    response(httpreponse ?? WeatherModel())
                }else{
                    response(WeatherModel())
                }
        }
        
    }
    
    
}
 