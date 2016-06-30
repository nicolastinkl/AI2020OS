# JS SDK 文档

Demo

```
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title></title>
  <script>
    function getUserInfo() {
      ai.getUserInfo(function(data) {
        //data {
        //  userName: userName
        //  userId: userId
        //}
        document.getElementById("userInfo").textContent = JSON.stringify(data)
      })
    }

    function getDeviceInfo() {
      ai.getDeviceInfo(function(data) {
        // data {
          // deviceType: deviceType,
          // systemVersion: systemVersion,
          // systemName: systemName
        // }
        document.getElementById("deviceInfo").textContent = JSON.stringify(data)
      })
    }
  </script>
</head>

<body>
  <p>device info</p>
  <p id='deviceInfo'></p>
  <p>user info</p>
  <p id='userInfo'></p>
  <form action="">
    <input type="button" value="get device version" onclick="getDeviceInfo()">
    <input type="button" value="get user name" onclick="getUserInfo()">
  </form>
</body>

</html>
```
