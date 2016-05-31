//
//  Localize.swift
//  Localize
//
//  Created by Roy Marmelstein on 05/08/2015.
//  Copyright © 2015 Roy Marmelstein. All rights reserved.
//

import Foundation

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "en"

/// Name for language change notification
public let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

// MARK: Localization Syntax

/**
Swift 1.x friendly localization syntax, replaces NSLocalizedString
- Parameter string: Key to be localized.
- Returns: The localized string.
*/
public func Localized(string: String) -> String {
    if let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj"), bundle = NSBundle(path: path) {
        return bundle.localizedStringForKey(string, value: nil, table: nil)
    }
    return string
}

/**
 Swift 1.x friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
 - Parameter string: Key to be localized.
 - Returns: The formatted localized string with arguments.
 */
public func Localized(string: String, arguments args: CVarArgType...) -> String {
    return String(format: Localized(string), arguments: args)
}

public extension NSString {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    func localized() -> NSString {
        if let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj"), bundle = NSBundle(path: path) {
            return bundle.localizedStringForKey(self as String, value: nil, table: nil)
        }
        return self
    }
    
    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedWithFormat(arguments args: CVarArgType) -> NSString {
        return NSString(format: localized(), args)
//        NSString(format: <#T##NSString#>, CVarArgType)
    }
}

public extension String {
    /**
     Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    var localized: String {
        if let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj"), bundle = NSBundle(path: path) {
            return bundle.localizedStringForKey(self, value: nil, table: nil)
        }
        return self
    }

    /**
     Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedWithFormat(arguments args: CVarArgType...) -> String {
        return String(format: localized, arguments: args)
    }
}



// MARK: Language Setting Functions

public class Localize: NSObject {
    
    /**
     List available languages
     - Returns: Array of available languages.
     */
    public class func availableLanguages() -> [String] {
        return NSBundle.mainBundle().localizations
    }
    
    /**
     Current language
     - Returns: The current language. String.
     */
    public class func currentLanguage() -> String {
        if let currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(LCLCurrentLanguageKey) as? String {
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    /**
     Change the current language
     - Parameter language: Desired language.
     */
    public class func setCurrentLanguage(language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if (selectedLanguage != currentLanguage()){
            NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: LCLCurrentLanguageKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(LCLLanguageChangeNotification, object: nil)
        }
    }
    
    /**
     Default language
     - Returns: The app's default language. String.
     */
    class func defaultLanguage() -> String {
        // 强制默认英语
        return "en"
//        var defaultLanguage: String = String()
//        guard let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first else {
//            return LCLDefaultLanguage
//        }
//        let availableLanguages: [String] = self.availableLanguages()
//        if (availableLanguages.contains(preferredLanguage)) {
//            defaultLanguage = preferredLanguage
//        }
//        else {
//            defaultLanguage = LCLDefaultLanguage
//        }
//        return defaultLanguage
    }
    
    /**
     Resets the current language to the default
     */
    public class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
    
    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    public class func displayNameForLanguage(language: String) -> String {
        let locale : NSLocale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayNameForKey(NSLocaleLanguageCode, value: language) {
            return displayName
        }
        return String()
    }
}
