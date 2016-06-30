;
(function() {
    if (window.ai) {
        return
    }

    // private 
    function connectToSwiftWebViewBridge(callback) {
        if (window.SwiftWebViewBridge) {
            callback(SwiftWebViewBridge)
        } else {
            document.addEventListener('SwiftWebViewBridgeReady', function() {
                callback(SwiftWebViewBridge)
            }, false)
        }
    }

    connectToSwiftWebViewBridge(function(bridge) {
        bridge.init(function(message, responseCallback) {
            var data = {
                'JS Responds': 'Message received = )'
            }
            responseCallback(data)
        })
    });

    // api
    function getUserInfo(cb) {
        SwiftWebViewBridge.callSwiftHandler("getUserInfo", null, function(responseData) {
            cb(responseData)
        })
    }

    function getDeviceInfo(cb) {
        SwiftWebViewBridge.callSwiftHandler("getDeviceInfo", null, function(responseData) {
            cb(responseData)
        })
    }
    // export api
    window.ai = {
        getUserInfo: getUserInfo,
        getDeviceInfo: getDeviceInfo
    }

    // send ready 
    var doc = document
    var readyEvent = doc.createEvent('Events')
    readyEvent.initEvent('JSSDKReady')
    doc.dispatchEvent(readyEvent)
})();
