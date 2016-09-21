import Foundation

public class AIAnalytics: NSObject {
	
	static let formatter: NSDateFormatter = {
		let result = NSDateFormatter()
		result.dateFormat = "yyyy-MM-HH:mm:ss"
		return result
	}()
	
	private class func commonParams() -> [String: String] {
		let result: [String: String] = [
			AIAnalyticsKeys.PartyID.rawValue: AILocalStore.userId.toString() ?? "0",
			AIAnalyticsKeys.Date.rawValue: formatter.stringFromDate(NSDate())
		]
		return result
	}
	
	class func convertAtt(input: [AIAnalyticsKeys: AnyObject]) -> [String: AnyObject] {
		var result = [String: AnyObject]()
		for (key, value) in input {
			result[key.rawValue] = value
		}
		return result
	}
	
	class func sendAnchor(anchor: AIAnchor) {
		let string = anchor.toJSONString()
		if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
			if let dic = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
				AVAnalytics.event(AIAnalyticsEvent.RemoteAssistant.rawValue, attributes: dic)
			}
		}
	}
	
	class func postToServer(eventId: AIAnalyticsEvent, primarykey: String? = nil, attributes: [AIAnalyticsKeys: AnyObject]!) {
		let url = "http://10.5.1.249:3245/events"
		let message = AIMessage()
		message.url = url
        var body: [String: AnyObject] = ["event": eventId.rawValue]
		body.addEntriesFromDictionary(body)
		body.addEntriesFromDictionary(commonParams())
        body.addEntriesFromDictionary(convertAtt(attributes))
		message.body = NSMutableDictionary(dictionary: body)
		AINetEngine.defaultEngine().postMessage(message, success: { (_) in }) { (_, _) in }
	}
	
	/** 自定义事件,数量统计.
     @param  eventId 自定义的事件Id.
     @param  attributes 支持字符串和数字的key-value */
	class func event(eventId: AIAnalyticsEvent, attributes: [AIAnalyticsKeys: AnyObject]!) {
		postToServer(eventId, attributes: attributes)
	}
	
	/** 自定义事件,时长统计， 记录事件开始。
     @param eventId 自定义事件的Id.
     @param keyName 自定义关键事件的标签. 关键事件标签用于区分同名事件，但不参与统计运算结果.
     @param attributes 自定义事件的属性列表.
     */
	class func beginEvent(eventId: AIAnalyticsEvent, primarykey keyName: String? = nil, attributes: [AIAnalyticsKeys: AnyObject]!) {
		var att = attributes
		att.addEntriesFromDictionary([AIAnalyticsKeys.Time: "begin"])
		postToServer(eventId, primarykey: keyName, attributes: att)
	}
	
	/** 自定义事件,时长统计， 记录事件结束。
     @param eventId 自定义事件的Id.
     @param keyName 自定义关键事件的标签. 关键事件标签用于区分同名事件，但不参与统计运算结果.
     */
	class func endEvent(eventId: AIAnalyticsEvent, primarykey keyName: String? = nil) {
		postToServer(eventId, primarykey: keyName, attributes: [AIAnalyticsKeys.Time: "end"])
	}
}

// 给PageShow 事件加入参数
protocol AIAnalyticsPageShowProtocol: NSObjectProtocol {
	func analyticsPageShowParam() -> [AIAnalyticsKeys: AnyObject]
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
		var att: [AIAnalyticsKeys: AnyObject] = [
				.ClassName: instanceClassName(),
				.Title: title ?? ""
		]
		if let p = self as? AIAnalyticsPageShowProtocol {
			att.addEntriesFromDictionary(p.analyticsPageShowParam())
		}
		AIAnalytics.beginEvent(.PageShow, primarykey: instanceClassName(), attributes: att)
	}
	
	func _analyticsViewDidDisappear(animated: Bool) {
		_analyticsViewDidDisappear(animated)
		AIAnalytics.endEvent(.PageShow, primarykey: instanceClassName())
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
