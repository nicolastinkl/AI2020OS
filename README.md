# AI2020OS
[![](https://img.shields.io/packagist/l/doctrine/orm.svg)]()
![](https://img.shields.io/github/release/qubyte/rubidium.svg)
![](https://img.shields.io/cocoapods/p/AFNetworking.svg)

# 一： 准备账号 和 git ssh key



- 1 www.github.com 添加个人本地rsa_key密钥信息，在 

	https://github.com/settings/ssh/ 处加入你本地的rsa key
 
- 2 加入私有repo源到本机 `pod repo add gameworksLibSpec git@bitbucket.org:tinkl/podspec.git`

- 3 在项目Podfile文件里` pod "GWGameKitLib",:head`

-  4   `pod install --verbose` and `pod update`


---------------


- 前提是大家需要安装[gem](gem.com) 和 [cocoapods](http://cocoapods.org/)
- *参考:*
	- [http://www.cocoachina.com/industry/20140623/8917.html](http://www.cocoachina.com/industry/20140623/8917.html)
	- [http://www.cnblogs.com/brycezhang/p/4117180.html](http://www.cnblogs.com/brycezhang/p/4117180.html)






# 二：移动端IOS版本App项目地址

1. git : https://github.com/nicolastinkl/AI2020OS
2. wiki: https://github.com/nicolastinkl/AI2020OS/wiki
3. 每位成员需要创建个人branch


# 三：规范


## 1. 语言规范

- 参考apple官方: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html#//apple_ref/doc/uid/20001282-BCIGIJJF

```
 #!函数注释的格式为
/**
 *  @brief  
 *  @param
 *  @return
 **/
在brief中需要写明函数的主要功能、注意事项 在param中需要写明函数的变量类型、变量的作用 在return中需要写明函数的返回类型、返回值的作用

```

-------

```
变量的命名

成员变量应该已小写字母开头，并以下划线作为后缀，如usernameTextField_,使用KVO/KVC绑定成员变量时，可以以一个下划线为前缀。

公共变量命名: 小写字母开头。如:imageView;

实例变量命名:

私有变量: 应该以下划线开头。如:_addButton

常量命名: 以小写k开头，混合大小写。如:kInvalidHandle, kWritePerm


```

-------


```

图片的命名

应该已“模块+功能+作用+样式”的形式

如:message_private_at_button_bg_normal.png

```

--------


```
类名、分类名、协议名

应该以大写字母开始，并混合小写字母来分隔单词，应该已“模块+功能+子功能”的方式：

如:MessagePrivateAtsomebody
应用级的类，应避免不用前缀，跨应用级的类，应使用前缀， objc 如:GTMSendMessage

```


---------


```

if和else应该和左大括号在同一行

如:
if (button.enabled) {
    // Stuff
} else if (otherButton.enabled) {
    // Other stuff
} else {
    // More stuf
}
Switch 也是一样

如:
switch (something.state) {......


```


## 2. Git提交规范

- 添加功能 Added(大模块+子模块):#实现某个功能
- 修改功能 Changed(大模块+子模块):#修改某个功能
- 修复BUG Fix(大模块+子模块):#修复什么bug(最好写上*原因*和*解决方法*
)
- 修改文档：Docs():  #
- 修改样式：Style():  #
- 添加测试 Test(大模块+子模块): #
- 代码重构:Refactor(大模块+子模块): #

> 问题描述不要过长，简洁为主
