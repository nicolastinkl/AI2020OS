//
//  AIFavoritsCommond.swift
//  AI2020OS
//
//  Created by tinkl on 28/4/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIFavoritsCommand  {
    
    typealias FavoritsLoaderCompletion = (stories: [AnyObject]) ->()
    
    enum FavoritsSection : Printable {
        case Facilitator
        case Content
        case Services
        
        var description : String {
            switch (self) {
                
            case .Facilitator: return "服务商"
            case .Content: return "内容"
            case .Services: return "服务"
            }
        }
    }
    
    private (set) var hasMore : Bool = false
    private var page : Int = 1
    private var isLoading : Bool = false
    private let section : FavoritsSection
    
    init(_ section:FavoritsSection = .Content){
        self.section = section
    }
    
    func loadMore(currentPage: Int = 1,completion: FavoritsLoaderCompletion){
        if isLoading {
            return
        }
        isLoading = true
        ++page
        AIHttpEngine.moviesForSection {  [weak self] movies  in
            if let strongSelf = self {
                strongSelf.isLoading = false                
            }
        }
    }
    
}