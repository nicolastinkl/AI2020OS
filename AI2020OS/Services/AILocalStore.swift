//
//  AILocalStore.swift
//  DesignerNewsApp
//
//  Created by tinkl on 30/3/15.
//  Copyright (c) 2015 ___ASIAINFO___. All rights reserved.
//

import UIKit

/*!
*  @author tinkl, 15-05-05 19:05:21
*
*  本地UserDefault存储处理
*/
struct AILocalStore {
    private static let visitedStoriesKey = "visitedStoriesKey"
    private static let upvotedStoriesKey = "upvotedStoriesKey"
    private static let repliedStoriesKey = "repliedStoriesKey"
    private static let upvotedCommentsKey = "upvotedCommentsKey"
    private static let accessTokenKey   = "accessTokenKey"
    
    private static let accessUserIDKey  = "accessUserIDKey"
    private static let accessUserIDKey1  = "accessUserIDKey1"
    private static let accessUserIDKey2  = "accessUserIDKey2"
    private static let accessUserIDKey3  = "accessUserIDKey3"
    private static let accessUserIDKey4  = "accessUserIDKey4"
    private static let accessUserIDKey5  = "accessUserIDKey5"
    private static let accessUserIDKey6  = "accessUserIDKey6"
    private static let accessUserIDKey7  = "accessUserIDKey7"
    private static let accessMenuTag    = "menuTag"
    
    private static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    static func setIntroAsVisited() {
        userDefaults.setObject(true, forKey: "introKey")
    }
    
    static func isIntroVisited() -> Bool {
        return userDefaults.boolForKey("introKey")
    }
    
    static func setAccessMenuTag(tag:Int){
        userDefaults.setObject(tag, forKey: accessMenuTag)
    }
    
    static func setStoryAsReplied(storyId: Int) {
        appendId(storyId, toKey: repliedStoriesKey)
    }
    
    static func setStoryAsVisited(storyId: Int) {
        appendId(storyId, toKey: visitedStoriesKey)
    }
    
    static func setStoryAsUpvoted(storyId: Int) {
        appendId(storyId, toKey: upvotedStoriesKey)
    }
    
    static func removeStoryFromUpvoted(storyId: Int) {
        removeId(storyId, forKey: upvotedStoriesKey)
    }
    
    static func setCommentAsUpvoted(commentId: Int) {
        appendId(commentId, toKey: upvotedCommentsKey)
    }
    
    static func removeCommentFromUpvoted(commentId: Int) {
        removeId(commentId, forKey: upvotedCommentsKey)
    }
    
    static func isStoryReplied(storyId: Int) -> Bool {
        return arrayForKey(repliedStoriesKey, containsId: storyId)
    }
    
    static func isStoryVisited(storyId: Int) -> Bool {
        return arrayForKey(visitedStoriesKey, containsId: storyId)
    }
    
    static func isStoryUpvoted(storyId: Int) -> Bool {
        return arrayForKey(upvotedStoriesKey, containsId: storyId)
    }
    
    static func isCommentUpvoted(commentId: Int) -> Bool {
        return arrayForKey(upvotedCommentsKey, containsId: commentId)
    }
    
    static func setAccessToken(token: String) {
        userDefaults.setObject(token, forKey: accessTokenKey)
        userDefaults.synchronize()
    }
    
    private static func deleteAccessToken() {
        userDefaults.removeObjectForKey(accessTokenKey)
        userDefaults.removeObjectForKey(accessUserIDKey)
        userDefaults.synchronize()
    }
    
    static func removeUpvotes() {
        userDefaults.removeObjectForKey(upvotedStoriesKey)
        userDefaults.removeObjectForKey(upvotedCommentsKey)
        userDefaults.synchronize()
    }
    
    static func accessToken() -> String? {
        return userDefaults.stringForKey(accessTokenKey)
    }
    
    static func setUIDToken(token: Int) {
        userDefaults.setInteger(token, forKey: accessUserIDKey)
        userDefaults.synchronize()
    }
    
    static func uidToken() -> Int? {
        return userDefaults.integerForKey(accessUserIDKey)
    }
    
    static func setCachaUserInfo(model: AIUserInfoModel){
        
        userDefaults.setObject(model.user_id ?? 0, forKey: accessUserIDKey)
        userDefaults.setObject(model.user_name ?? "", forKey: accessUserIDKey1)
        userDefaults.setObject(model.email ?? "", forKey: accessUserIDKey2)
        userDefaults.setObject(model.phone ?? "", forKey: accessUserIDKey3)
        userDefaults.setObject(model.wx_openid ?? "", forKey: accessUserIDKey4)
        userDefaults.setObject(model.imageurl ?? "", forKey: accessUserIDKey5)
        userDefaults.setObject(model.customer_id ?? 0, forKey: accessUserIDKey6)
        userDefaults.setObject(model.provider_id ?? 0, forKey: accessUserIDKey7)
        
        userDefaults.synchronize()
        
        
    }
    
    static func getUserInfoCache() -> AIUserInfoModel?{
        var model = AIUserInfoModel()
        model.user_id = userDefaults.integerForKey(accessUserIDKey)
        model.user_name = userDefaults.stringForKey(accessUserIDKey1)
        model.email = userDefaults.stringForKey(accessUserIDKey2)
        model.phone = userDefaults.stringForKey(accessUserIDKey3)
        model.wx_openid = userDefaults.stringForKey(accessUserIDKey4)
        model.imageurl = userDefaults.stringForKey(accessUserIDKey5)
        model.customer_id = userDefaults.integerForKey(accessUserIDKey6)
        model.provider_id = userDefaults.integerForKey(accessUserIDKey7)
        return model
    }
    
    static func logout() {
        self.deleteAccessToken()
    }
    
    // MARK: Helper
    
    static private func arrayForKey(key: String, containsId id: Int) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return contains(elements, id)
    }
    
    static private func appendId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !contains(elements, id) {
            userDefaults.setObject(elements + [id], forKey: key)
            userDefaults.synchronize()
        }
    }
    
    static private func removeId(id: Int, forKey key: String) {
        var elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if let index = find(elements, id) {
            elements.removeAtIndex(index)
            userDefaults.setObject(elements, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    static func  getAccessMenuTag() -> Int{
        return userDefaults.integerForKey(accessMenuTag) ?? 0
    }
}
