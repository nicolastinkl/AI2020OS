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
    private static let accessTokenKey = "accessTokenKey"

    private static let accessMenuTag = "menuTag"

    private static let userDefaults = NSUserDefaults.standardUserDefaults()

    static func setIntroAsVisited() {
        userDefaults.setObject(true, forKey: "introKey")
    }

    static func isIntroVisited() -> Bool {
        return userDefaults.boolForKey("introKey")
    }

    static func setAccessMenuTag(tag: Int) {
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

    //MARK: 处理登录信息
    static func logout() {
        self.deleteAccessToken()
        userDefaults.removeObjectForKey(AILoginUtil.KEY_USER_ID)
        userDefaults.removeObjectForKey(AILoginUtil.KEY_USER_NAME_STRING)
        userDefaults.removeObjectForKey(AILoginUtil.KEY_CUSTOM_ID)
        userDefaults.removeObjectForKey(AILoginUtil.KEY_PROVIDER_ID)
        userDefaults.removeObjectForKey(AILoginUtil.KEY_HEADURL_STRING)
        userDefaults.synchronize()

        /// Handle Provider Notification
        let installation = AVInstallation.currentInstallation()
        installation.setObject("000", forKey: "ProviderIdentifier")
        installation.removeObjectForKey("channels")
        installation.saveInBackground()
    }

    static func storageLoginInfo(info: [NSString: AnyObject]) {

        if let user_id = info["user_id"] as? String {
            userDefaults.setObject(user_id, forKey: AILoginUtil.KEY_USER_ID)

            /// Handle Provider Notification
            let installation = AVInstallation.currentInstallation()
            installation.setObject(user_id, forKey: "ProviderIdentifier")
            installation.addUniqueObject("ProviderChannel", forKey: "channels")
            installation.saveInBackground()
        }

        if let user_name = info["user_name"] as? String {
            userDefaults.setObject(user_name, forKey: AILoginUtil.KEY_USER_NAME_STRING)
        }

        if let customer_id = info["customer_id"] as? String {
            userDefaults.setObject(customer_id, forKey: AILoginUtil.KEY_CUSTOM_ID)
        }


        if let provider_id = info["provider_id"] as? String {
            userDefaults.setObject(provider_id, forKey: AILoginUtil.KEY_PROVIDER_ID)
        }

        if let head_url = info["head_url"] as? String {
            userDefaults.setObject(head_url, forKey: AILoginUtil.KEY_HEADURL_STRING)
        }

        userDefaults.synchronize()

    }

    static func didUserLogIn() -> Bool {
        return (userDefaults.objectForKey(AILoginUtil.KEY_USER_ID) != nil)
    }

    // MARK: Helper

    static private func arrayForKey(key: String, containsId id: Int) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []

        return elements.contains(id)
    }

    static private func appendId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !elements.contains(id) {
            userDefaults.setObject(elements + [id], forKey: key)
            userDefaults.synchronize()
        }
    }

    static private func removeId(id: Int, forKey key: String) {
        var elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        let results = elements.filter { (findObject) -> Bool in
            return findObject == id
        }
        if let index = results.first {
            elements.removeAtIndex(index)
            userDefaults.setObject(elements, forKey: key)
            userDefaults.synchronize()
        }
    }

    static func  getAccessMenuTag() -> Int {
        return userDefaults.integerForKey(accessMenuTag) ?? 0
    }
}
