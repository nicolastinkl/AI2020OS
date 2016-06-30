# JS SDK 文档

## 基础接口

### 调用方法

```
// 注意: 只能在JSSDKReady以后调用 接口
document.addEventListener('JSSDKReady', function() {
    var cb = function(data) { console.log(data) }
    ai.getUserInfo(cb)
    ai.getDeviceInfo(cb)
}, false)

```

### 获取用户信息

```
ai.getUserInfo(function(data) {
    var userName = data.userName
    var userId = data.userId
})
```

### 获取设备信息

```
ai.getDeviceInfo(function(data) {
    var deviceType = data.deviceType
    var systemVersion = data.systemVersion
    var systemName = data.systemName
})
```


[Demo.html](https://gist.github.com/bumaociyuan/5e240443ecf1882cb6df4b6221b62d58)
