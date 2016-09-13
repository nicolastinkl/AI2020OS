import Foundation

public class AIAnalytics: NSObject {
	
	static let formatter: NSDateFormatter = {
		let result = NSDateFormatter()
		result.dateFormat = "yyyy-MM-hh"
		return result
	}()
	
	private class func commonParams() -> [NSObject: AnyObject] {
		let result = [
			"partyID": AILocalStore.userId ?? 0,
			"date": formatter.stringFromDate(NSDate())
		]
		return result as [NSObject: AnyObject]
	}
	
	/** 自定义事件,数量统计.
     @param  eventId 自定义的事件Id.
     @param  attributes 支持字符串和数字的key-value */
	public class func event(eventId: String!, attributes: [NSObject: AnyObject]!) {
		var att = attributes
		att.addEntriesFromDictionary(commonParams())
		AVAnalytics.event(eventId, attributes: att)
	}
	
	/** 自定义事件,时长统计， 记录事件开始。
     @param eventId 自定义事件的Id.
     @param keyName 自定义关键事件的标签. 关键事件标签用于区分同名事件，但不参与统计运算结果.
     @param attributes 自定义事件的属性列表.
     */
	public class func beginEvent(eventId: String!, primarykey keyName: String? = nil, attributes: [NSObject: AnyObject]!) {
		var att = attributes
		att.addEntriesFromDictionary(commonParams())
		AVAnalytics.beginEvent(eventId, primarykey: keyName ?? "", attributes: att)
	}
	
	/** 自定义事件,时长统计， 记录事件结束。
     @param eventId 自定义事件的Id.
     @param keyName 自定义关键事件的标签. 关键事件标签用于区分同名事件，但不参与统计运算结果.
     */
	public class func endEvent(eventId: String!, primarykey keyName: String? = nil) {
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
		AIAnalytics.beginEvent("pageShow", attributes: [
			"className": instanceClassName(),
			"title": title ?? ""
		])
	}
	
	func _analyticsViewDidDisappear(animated: Bool) {
		_analyticsViewDidDisappear(animated)
		AIAnalytics.endEvent("pageShow")
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
