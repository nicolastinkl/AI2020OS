//
//  AISearchResultModel.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// 搜索结果Model
public class AISearchResultModel: JSONModel {
    //返回搜索关键字
    public var searchkeyname: NSString = ""
    //过滤条件数据
    public var searchFilter: Array<NSDictionary>?
    //结果数据集
    public var results: Array<NSDictionary>?
    //推荐数据集
    public var results_proposal_list: Array<NSDictionary>?
    
}

/// 过滤条件
public class AISearchFilterModel: JSONModel {
    
    public var filterid: NSInteger = 0
    public var filtername: NSString = ""
}

/// 结果数据集
public class AISearchResultItemModel: JSONModel {
    
    public var service_id: NSInteger = 0
    public var service_name: NSString = ""
    public var service_price: NSString = ""
    public var service_second_name: NSString = ""
    public var service_icon_url: NSString = ""
    public var service_description: NSString = ""
    public var service_comment_scroce: NSInteger = 0
    public var service_likes: NSInteger = 0
    public var service_browse: NSInteger = 0
    
    public var service_introduction: NSString = ""
    public var service_superiority: [NSString] = []
    public var service_superiority_icon: [NSString] = []
    
}


