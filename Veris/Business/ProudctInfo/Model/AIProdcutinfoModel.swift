//
//  AIProdcutinfoModel.swift
//  AIVeris
//
//  Created by tinkl on 8/3/16.
//  Copyright © 2016 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIProdcutinfoModel: JSONJoy {
 
    //var serviceID: Int?
    var name: String?
    var image: String?
    var desc: String?
    var desc_image: String?
    var proposal_inst_id: Int?
    var price: AIPricePublicModel?
    var collected: Bool = false
    var intro_urls: [String]?
    
    var package: [AIProductInfoPackageModel]?
    
    var customer_note: AIProductInfoCustomerNote?
    
    var recommendation: [AIProductRecommendationModel]?
    
    var provider: AIPublicProviderModel?
    
    var commentLast: AICommentInfoModel?
    
    required init(_ decoder: JSONDecoder) {
        
        // base_info
        if let bdecoder = decoder["base_info"].dictionary {
            
            name = bdecoder["name"]?.string ?? ""
            desc = bdecoder["desc"]?.string ?? ""
            image = bdecoder["image"]?.string ?? ""
            desc_image = bdecoder["desc_image"]?.string ?? ""
            proposal_inst_id = bdecoder["proposal_inst_id"]?.integer ?? 0
            collected = bdecoder["collected"]?.bool ?? false
            
            //package
            package = Array<AIProductInfoPackageModel>()
            if let rmlist = bdecoder["package"]?.array {
                for dec in rmlist {
                    let pro = AIProductInfoPackageModel(dec)
                    package?.append(pro)
                }
            }
            if let json  = bdecoder["price"] {
                price = AIPricePublicModel(json)
            }
            
            intro_urls = Array<String>()
            if let arrayNew = bdecoder["intro_urls"]?.array {
                for item in arrayNew {
                    intro_urls?.append(item["service_intro_url"].string ?? "")
                }
            }
        }
        
        
        
        //customer_note
        customer_note = AIProductInfoCustomerNote(decoder["customer_note"])
        
        //recommendation
        recommendation = Array<AIProductRecommendationModel>()
        if let rmlist = decoder["recommendation"].array {
            for dec in rmlist {
                let pro = AIProductRecommendationModel(dec)
                recommendation?.append(pro)
            }
        }
        
        //comment
        commentLast = AICommentInfoModel(decoder["judgement"])
        
        //provider
        provider = AIPublicProviderModel(decoder["provider"])
        
    }
    
}

struct AIPublicProviderModel: JSONJoy {
    
    var id: Int?
    var name: String?
    var icon: String?
    var desc: String?
    var service_times: String?
    var good_rate: String?
    var service_level: String?
    
    init(_ decoder: JSONDecoder) {
        id = decoder["id"].integer ?? 0
        name = decoder["name"].string ?? ""
        desc = decoder["desc"].string ?? ""
        icon = decoder["icon"].string ?? ""
        service_times = decoder["service_times"].string ?? ""
        good_rate = decoder["good_rate"].string ?? ""
        service_level = decoder["service_level"].string ?? ""
    }
    
}

// 服务推荐
struct AIProductRecommendationModel: JSONJoy {
    
    var name: String?
    var rid: Int?
    var order_time: String?
    var price: AIPricePublicModel?
    var sub_icons: [String]?
    init() {}
    init(_ decoder: JSONDecoder) {
        name = decoder["name"].string ?? ""
        rid = decoder["id"].integer ?? 0
        price = AIPricePublicModel(decoder["price"])
        order_time = decoder["order_time"].string ?? ""
        decoder["sub_icons"].getArray(&sub_icons)
    }
    
    
}

// Tag List
struct AIProductInfoTagListModel: JSONJoy {
    
    var instance_id: Int?
    var tag_id: Int?
    var name: String?
    var chosen_times: Int?
    var create_time: String?
    var is_chosen: Int?
    
    init(_ decoder: JSONDecoder) {
        instance_id = decoder["instance_id"].integer ?? 0
        tag_id = decoder["tag_id"].integer ?? 0
        chosen_times = decoder["chosen_times"].integer ?? 0
        is_chosen = decoder["is_chosen"].integer ?? 0
        name = decoder["name"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
    }
}

// Note List
struct AIProductInfoNoteListModel: JSONJoy {
    
    var nid: Int?
    var type: String?
    var content: String?
    var create_time: String?
    var duration: String?

    
    init(_ decoder: JSONDecoder) {
        nid = decoder["id"].integer ?? 0
        type = decoder["type"].string ?? ""
        content = decoder["content"].string ?? ""
        duration = decoder["duration"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        
    }
}



//Custom Note
struct AIProductInfoCustomerNote: JSONJoy {

    var wish_id: Int?
    var wish_name: String?
    var wish_desc: String?
    var service_id: Int?
    var tag_list: [AIProductInfoTagListModel]? = [AIProductInfoTagListModel]()
    var note_list: [AIProductInfoNoteListModel]? = [AIProductInfoNoteListModel]()
    
    init(_ decoder: JSONDecoder) {
     
        wish_id = decoder["wish_id"].integer ?? 0
        service_id = decoder["service_id"].integer ?? 0
        wish_name = decoder["wish_name"].string ?? ""
        wish_desc = decoder["wish_desc"].string ?? ""
        
        if let taglist = decoder["tag_list"].array {
            for dec in taglist {
                let pro = AIProductInfoTagListModel(dec)
                tag_list?.append(pro)
            }
        }
        
        if let taglist = decoder["note_list"].array {
            for dec in taglist {
                let pro = AIProductInfoNoteListModel(dec)
                note_list?.append(pro)
            }
        }
        
    }
}



struct AIProductInfoPackageModel: JSONJoy {
    
    var pid: Int?
    var name: String?
    var collected: Bool = false
    init(_ decoder: JSONDecoder) {
        pid = decoder["id"].integer ?? 0
        name = decoder["name"].string ?? ""
        collected = decoder["collected"].bool
    }
}
