import Foundation

public class AIAnalytics: NSObject {
	
	static let formatter: NSDateFormatter = {
		let result = NSDateFormatter()
		result.dateFormat = "yyyy-MM-hh"
		return result
	}()
	
	private class func commonParams() -> [AIAnalyticsKeys: AnyObject] {
		let result: [AIAnalyticsKeys: AnyObject] = [
				.PartyID: AILocalStore.userId ?? 0,
				.Date: formatter.stringFromDate(NSDate())
		]
		return result
	}
	
	private class func convertAtt(input: [AIAnalyticsKeys: AnyObject]) -> [NSObject: AnyObject] {
		var result = [NSObject: AnyObject]()
		for (key, value) in input {
			result[key.rawValue] = value
		}
		return result
	}
	
	/** 自定义事件,数量统计.
     @param  eventId 自定义的事件Id.
     @param  attributes 支持字符串和数字的key-value */
	class func event(eventId: AIAnalyticsEvent, attributes: [AIAnalyticsKeys: AnyObject]!) {
		var att = attributes
		att.addEntriesFromDictionary(commonParams())
		AVAnalytics.event(eventId.rawValue, attributes: convertAtt(att))
	}
	
	/** 自定义事件,时长统计， 记录事件开始。
     @param eventId 自定义事件的Id.
     @param keyName 自定义关键事件的标签. 关键事件标签用于区分同名事件，但不参与统计运算结果.
     @param attributes 自定义事件的属性列表.
     */
	class func beginEvent(eventId: AIAnalyticsKeys, primarykey keyName: String? = nil, attributes: [AIAnalyticsKeys: AnyObject]!) {
		var att = attributes
		att.addEntriesFromDictionary(commonParams())
		AVAnalytics.beginEvent(eventId.rawValue, primarykey: keyName ?? "", attributes: convertAtt(att))
	}
	
	/** 自定义事件,时长统计， 记录事件结束。
     @param eventId 自定义事件的Id.
     @param keyName 自定义关键事件的标签. 关键事件标签用于区分同名事件，但不参与统计运算结果.
     */
	class func endEvent(eventId: String!, primarykey keyName: String? = nil) {
		AVAnalytics.endEvent(eventId, primarykey: keyName ?? "")
	}
}

extension UIViewController {
	
	class func swizzlingMethod(clzz: AnyClass, oldSelector: Selector, newSelector: Selector) {
		let oldMethod = class_getInstanceMethod(clzz, oldSelector)
		let newMethod = class_getInstanceMethod(clzz, newSelector)
		method_exchangeImplementations(oldMethod, newMethod)
	}
	
	class func swizzleInit() {
		swizzlingMethod(UIViewController.self, oldSelector: #selector(UIViewController.viewDidAppear(_:)), newSelector: #selector(UIViewController._analyticsViewDidAppear(_:)))
		swizzlingMethod(UIViewController.self, oldSelector: #selector(UIViewController.viewDidDisappear(_:)), newSelector: #selector(UIViewController._analyticsViewDidDisappear(_:)))
	}
	
	func _analyticsViewDidAppear(animated: Bool) {
		_analyticsViewDidAppear(animated)
		AIAnalytics.beginEvent("pageShow", primarykey: instanceClassName(), attributes: [
			"className": instanceClassName(),
			"title": title ?? ""
		])
	}
	
	func _analyticsViewDidDisappear(animated: Bool) {
		_analyticsViewDidDisappear(animated)
		AIAnalytics.endEvent("pageShow", primarykey: instanceClassName())
	}
	
	public override class func initialize() {
		struct Static {
			static var token: dispatch_once_t = 0
		}
		
		if self !== UIViewController.self {
			return
		}
		
		dispatch_once(&Static.token) {
			swizzleInit()
		}
	}
}
