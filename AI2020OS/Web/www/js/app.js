// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
// 'starter.services' is found in services.js
// 'starter.controllers' is found in controllers.js
var service = angular.module('service', ['ionic', 'service.controllers', 'service.services'])
/*
.run(function($ionicPlatform) {
  $ionicPlatform.ready(function() {
    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
    // for form inputs)
    if (window.cordova && window.cordova.plugins && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      cordova.plugins.Keyboard.disableScroll(true);

    }
    if (window.StatusBar) {
      // org.apache.cordova.statusbar required
      StatusBar.styleLightContent();
    }
  });
})
*/
.constant('ApiEndpoint', {
  url: 'http://115.29.164.124:80/'
})

// .constant('ApiEndpoint', {
//   url: 'http://localhost:3000/api/endpoint'
// })

.run(function($ionicPlatform,$rootScope) {
	// 切换页面状态事件
	$rootScope.$on('$stateChangeSuccess', function(event, current, previous) {
     	var title = angular.element('#mtitle');
     	title.text(current.title)
 	});
	  $ionicPlatform.ready(function() {
	    // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
	    // for form inputs)
	    if (window.cordova && window.cordova.plugins.Keyboard) {
	      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
	    }
	    if (window.StatusBar) {
	      // org.apache.cordova.statusbar required
	      StatusBar.styleDefault();
	    }
	  });
})
.config(function($stateProvider, $urlRouterProvider) {

  // Ionic uses AngularUI Router which uses the concept of states
  // Learn more here: https://github.com/angular-ui/ui-router
  // Set up the various states which the app can be in.
  // Each state's controller can be found in controllers.js

  // setup an abstract state for the tabs directive
  $stateProvider
  .state('serviceCatelog', {
	    url: '/serviceCatelog',
	    cache: false,
	    title:'服务分类',
	    templateUrl: 'templates/serviceCatelog.html',
	    controller:"serviceCatelogCtrl"
  })
  .state('serviceInfo', {
	    url: '/serviceInfo/:cid',
	    cache: false,
	     title:'基本信息',
	    templateUrl: 'templates/serviceInfo.html',
	    controller:"serviceInfoCtrl"
  })
  .state('taskContent', {
	    url: '/taskContent',
	    cache: false,
	     title:'任务列表',
	    templateUrl: 'templates/taskContent.html',
	    controller:"taskContentCtrl"
  })
  .state('mapBargain', {
	    url: '/mapBargain',
	    cache: false,
	     title:'设定价格',
	    templateUrl: 'templates/mapBargain.html',
	    controller:"mapBargainCtrl"
 })
.state('setTags', {
	    url: '/setTags',
	    cache: false,
	    title:'设置标签',
	    templateUrl: 'templates/setTags.html',
	    controller:"setTagsCtrl"
 })
.state('photos', {
	    url: '/photos',
	    cache: false,
	    title:'添加图片',
	    templateUrl: 'templates/photos.html',
	    controller:"photosCtrl"
 })
.state('serviceDetail', {
	    url: '/serviceDetail',
	    cache: false,
	    title:'服务详情',
	    templateUrl: 'templates/serviceDetail.html',
	    controller:"serviceDetailCtrl"
 })
.state('selectProperty', {
	    url: '/selectProperty',
	    cache: false,
	    title:'设置参数',
	    templateUrl: 'templates/selectProperty.html',
	    controller:"photosCtrl"
 })
.state('templateList', {
	    url: '/templateList/:cid/:cnodeId',
	    cache: false,
	    title:'服务',
	    templateUrl: 'templates/templateList.html',
	    controller:"templateListCtrl"
 })
  // Each tab has its own nav history stack:

  // if none of the above states are matched, use this as the fallback
   $urlRouterProvider.when("", "/serviceCatelog");



});
