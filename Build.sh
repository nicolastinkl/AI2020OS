#!/bin/sh

#  AutoBuildShell.sh
#  UPPayServiceEx
#
#  Created by  on 12-7-2.
#  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
#up_iphone/workspace
#wxzhao/CVSProjects
#-------------------基准路径-------------------------------------------------------------------------------
cvsRoot=$PWD                          #UPPayPlugin 工程所在目录
patch_up_iphone="${cvsRoot}/patch_up_iphone"
patch_upmp_iphone="${cvsRoot}/patch_upmp_iphone"
#-------------------发布版本path---------------------------------------------------------------------------
versionRoot="${cvsRoot}/iPhoneVersions"
#UPPayPlugin sdk
sdk_path="${versionRoot}/sdk"
sdk_inc_path="$sdk_path"
sdk_lib_path="${sdk_path}/libs"
outputLib_path="${sdk_path}/libs/libUPPayPlugin.a"
pro_output_path="${sdk_path}/libs/libUPPayPluginPro.a"
#UPPayDemo
demo_path="${versionRoot}/demo"

#UPPayAssistant
assistant_path="${versionRoot}/assistant"
assistant_inc_path="${assistant_path}/inc"
assistant_lib_path="${assistant_path}/libs"

#UPPayService
service_path="${versionRoot}/service"


#-------------------创建目录--------------------------------------------------------------------------------------

mkdir "$versionRoot"



#---------------------------------------------------------------------------------------------------------

if [ "$1" = "n" ]
then
echo "未从cvs迁出UPMP_IPHONE目标码"

else

mkdir "$patch_upmp_iphone"

cd "$patch_upmp_iphone"

cvs co -r "$2" UPMP_IPHONE

cp -R "${patch_upmp_iphone}/upmp_iphone/sdk/libs/Release-iphoneos/libUPPayPlugin.a" "${cvsRoot}/service/UPPayServiceEx/UPPayPluginEx/libUPPayPlugin.a"

echo "从cvs迁出UPMP_IPHONE目标码成功！！"

#
fi
#----------------------------------------------------------------------------------------------------------


if [ "$2" = "plugin" ]
then


#---

plugin_path="${cvsRoot}/plugin"
iosLib_path="${plugin_path}/build/Release-iphoneos/libUPPayPlugin.a"
simLib_path="${plugin_path}/build/Release-iphonesimulator/libUPPayPlugin.a"

pro_iphoneos_path="${plugin_path}/build/Release-iphoneos/libUPPayPluginPro.a"
pro_simulator_path="${plugin_path}/build/Release-iphonesimulator/libUPPayPluginPro.a"



#创建sdk和demo相关的目录
mkdir "$sdk_path"
mkdir "$sdk_lib_path"
mkdir "$demo_path"



echo "***开始build UPPluginEx工程***"

cd "$plugin_path"         #打开插件工程目录

xcodebuild clean -configuration Release     #clean项目


echo "开始编译UPPayPlugin真机版本"


#编译命令
xcodebuild -project UPPayPluginEx.xcodeproj -target UPPayPluginExLib -configuration Release  -sdk iphoneos build    #开始编译工程

if [ -r "$iosLib_path" ];
then
cp -R "${plugin_path}/build/Release-iphoneos/inc" "$sdk_inc_path"
cp -R "$iosLib_path" "${cvsRoot}/demo/UPPayDemo/UPPayPlugin/libUPPayPlugin.a"
echo "UPPayPlugin真机编译成功！！"

fi


echo "开始编译UPPayPlugin模拟器版本"

xcodebuild -project UPPayPluginEx.xcodeproj -target UPPayPluginExLib -configuration Release  -sdk iphonesimulator build  #开始编译工程

if [ -r "$simLib_path" ];
then

echo "UPPayPlugin模拟器编译成功！！"

fi

echo "输出libUPPayPlugin.a库"

#---------------------------------------------编译合成UPPayPlugin静态库------------------------------------------------


lipo -create "$iosLib_path" "$simLib_path" -output "$outputLib_path"

if [ -r "$outputLib_path" ];

then
echo "UPPayPlugin打包成功！！"
else

echo "UPPayPlugin打包失败！！"

fi

#-------------------------------------------------------

echo "开始编译UPPayPluginPro真机版本"


#编译命令
xcodebuild -project UPPayPluginEx.xcodeproj -target UPPayPluginPro -configuration Release  -sdk iphoneos build    #开始编译工程
if [ -r "$pro_iphoneos_path" ];
then
cp -R "${plugin_path}/build/Release-iphoneos/inc" "$sdk_inc_path"
cp -R "$pro_iphoneos_path" "${cvsRoot}/service/UPPayServiceEx/UPPayPluginEx/libUPPayPluginPro.a"
cp -R "$pro_iphoneos_path" "${cvsRoot}/demo/UPPayDemoPro/UPPayDemoPro/UPPayPlugin/libUPPayPluginPro.a"
echo "UPPayPluginPro真机编译成功！！"

fi

echo "开始编译UPPayPluginPro模拟器版本"

xcodebuild -project UPPayPluginEx.xcodeproj -target UPPayPluginPro -configuration Release  -sdk iphonesimulator build  #开始编译工程

if [ -r "$pro_simulator_path" ];
then

echo "UPPayPluginPro模拟器编译成功！！"

fi



#---------------------------------------------编译合成UPPayPluginPro静态库------------------------------------------------


lipo -create "$pro_iphoneos_path" "$pro_simulator_path" -output "$pro_output_path"

if [ -r "$pro_output_path" ];

then
echo "UPPayPluginPro打包成功！！"
else

echo "UPPayPluginPro打包失败！！"

fi


#-------------------------------编译demo---------------------------------------------------------------------------
if [ -r "${cvsRoot}/demo/UPPayDemo/UPPayPlugin/libUPPayPlugin.a" ];
then

echo "开始编译demo工程"

cd "${cvsRoot}/demo"

xcodebuild clean -configuration Release   #clean项目

xcodebuild -project UPPayDemo.xcodeproj -target UPPayDemo -configuration Release  -sdk iphoneos build   #开始编译工程

echo "demo工程编译成功！！"
echo "开始打UPPayDemo.ipa包"

appFile="${cvsRoot}/demo/build/Release-iphoneos/UPPayDemo.app"  #app文件所在路径

#"iPhone Distribution:China Unionpay Co.,Ltd."

if [ -r "$appFile" ]; then
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "$appFile" -o "${demo_path}/UPPayDemo.ipa" #打包ipa

fi

if [ -r "${demo_path}/UPPayDemo.ipa" ]; then

echo "UPPayDemo.ipa打包成功！！"

else

echo "UPPayDemo.ipa打包失败！！"
fi


fi


#-----------------demoPro


if [ -r "${cvsRoot}/demo/UPPayDemoPro/UPPayDemoPro/UPPayPlugin/libUPPayPluginPro.a" ];
then

echo "开始编译UPPayDemoPro工程"

cd "${cvsRoot}/demo/UPPayDemoPro"

xcodebuild clean -configuration Release   #clean项目

xcodebuild -project UPPayDemoPro.xcodeproj -target UPPayDemoPro -configuration Release  -sdk iphoneos build   #开始编译工程

echo "UPPayDemoPro工程编译成功！！"
echo "开始打UPPayDemoPro.ipa包"

proAppFile="${cvsRoot}/demo/UPPayDemoPro/build/Release-iphoneos/UPPayDemoPro.app"  #app文件所在路径

#"iPhone Distribution:China Unionpay Co.,Ltd."

if [ -r "$proAppFile" ]; then
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "$proAppFile" -o "${demo_path}/UPPayDemoPro.ipa" #打包ipa

fi

if [ -r "${demo_path}/UPPayDemoPro.ipa" ]; then

echo "UPPayDemoPro.ipa打包成功！！"

else

echo "UPPayDemoPro.ipa打包失败！！"
fi


fi





#-----------------

else
#

echo "不编译plugin工程"

fi
#----------------------------------------------------------------------------------------------------------

if [ "$3" = "assistant" ]
then

#路径
iosLib_path="build/Release-iphoneos/libUPPayAssistant.a"
simLib_path="build/Release-iphonesimulator/libUPPayAssistant.a"

#创建assistant目录
mkdir "$assistant_path"
mkdir "$assistant_inc_path"
mkdir "$assistant_lib_path"


echo "开始编译assitant工程"


cd "${cvsRoot}/assitant"         #打开插件工程目录

xcodebuild clean -configuration Release     #clean项目

echo "开始编译assistant真机版本"


#编译命令
xcodebuild -project UPPayAssistant.xcodeproj -target UPPayAssistant -configuration Release  -sdk iphoneos build    #开始编译工程

if [ -r "$iosLib_path" ];
then
cp -R "build/Release-iphoneos" "$assistant_lib_path"
echo "assistant真机编译成功"

fi


echo "开始编译assistant模拟器版本"



xcodebuild -project UPPayAssistant.xcodeproj -target UPPayAssistant -configuration Release  -sdk iphonesimulator build  #开始编译工程

if [ -r "$simLib_path" ];
then
cp -R "build/Release-iphonesimulator" "$assistant_lib_path"
echo "assistant模拟器编译成功"

fi


cp -R "include/UPPayAssistant.h" "$assistant_inc_path"



#echo "输出libUPPayAssistant.a库"

#cd "${versionRoot}/assitant"

#lipo -create "$simLib_path" "$iosLib_path" -output libUPPayAssistant.a

#rm -rf "$simulatorDir"
#rm -rf "$iosDir"
#if [ -r "${versionRoot}/assitant/libUPPayAssistant.a" ];
#then
#echo "输出libUPPayAssistant.a库成功！！"
#fi



else
echo "不编译assistant工程"

fi

#----------------------------------------------------------------------------------------------------------

#----------------------------------------------------------------------------------------------------------

if [ "$4" = "service" ]
then

mkdir "$service_path"




echo "开始编译service工程"

cd "${cvsRoot}/service"         #打开插件工程目录
#Distribution
xcodebuild clean -configuration Distribution     #clean项目


#编译命令
xcodebuild -project UPPayServiceEx.xcodeproj -target UPPayServiceEx -configuration Distribution  -sdk iphoneos build    #开始编译工程

echo "编译service工程成功！！"
echo "开始打安全支付助手.ipa包"

appFile="${cvsRoot}/service/build/Distribution-iphoneos/安全支付助手.app"  #app文件所在路径
ipaDir="${service_path}/安全支付助手.ipa"     #打包根目录

#"iPhone Distribution:China Unionpay Co.,Ltd."

if [ -r "$appFile" ]
then

/usr/bin/xcrun -sdk iphoneos PackageApplication -v "$appFile" -o "$ipaDir" #打包ipa

fi


else
echo "不编译service工程"
fi



echo "***********************************************"
echo "****************脚本运行结果*********************"
echo "***********************************************"

if [ "$2" = "plugin" ];
then

if [ -r "$outputLib_path" ] && [ -f "${demo_path}/UPPayDemo.ipa" ];
then
echo "****       plugin工程编译成功                ****"
else
echo "****       plugin工程编译失败                ****"
fi

else
echo "****       此次未编译plugin工程              ****"
fi

if [ "$3" = "assistant" ];
then

if [ -r "${assistant_lib_path}/Release-iphoneos/libUPPayAssistant.a" ] && [ -r "${assistant_lib_path}/Release-iphonesimulator/libUPPayAssistant.a" ];
then
echo "****       assistant工程编译成功             ****"
else
echo "****       assistant工程编译失败             ****"
fi

else
echo "****       此次未编译assistant工程           ****"
fi


if [ "$4" = "service" ];
then

if [ -r "${service_path}/安全支付助手.ipa" ];
then
echo "****       service工程编译成功               ****"
else
echo "****       service工程编译失败               ****"
fi

else
echo "****       此次未编译service工程             ****"
fi

echo "***********************************************"
echo "***********************************************"
echo "***********************************************"











