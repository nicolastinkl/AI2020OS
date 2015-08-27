angular.module('service.controllers', ['ionic'])

.controller("serviceCatelogCtrl",function($scope, Api,$ionicLoading,$http,ApiEndpoint,$timeout){
	$scope.$on('$routeChangeSuccess', function (event, current, previous) {
		console.log(current);
        
    });
	// 获取一级分类
	Api.getApiData('get','service/queryIndustryList')
	.then(function(result) {
		console.log(result)
		if( result.desc.result_code && result.desc.result_code==200){ 
			$scope.catalogList = result.data.catalog_list;
			var firId = $scope.catalogList[0].catalogId;
			getCatelogNodes(firId);
		}
	});
	// 获取二级分类
	function getCatelogNodes(id){ 
		var promise = $http({
	        method :'get',
	        cache:false,
	        url:ApiEndpoint.url+'service/queryIndustryCatalog/'+id,
   		});
   		promise.then(function(res){ 
   			// #/templateList/{{nodes.catalogId}}/{{nodes.catalogNodeId}}
   			var res = res.data;
   			if( res.desc.result_code && res.desc.result_code==200){ 
					var catalogNodes = res.data.catalogNodes;
					for(var i=0;i<catalogNodes.length;i++){ 
						catalogNodes[i].url = '#/templateList/'+id+'/'+catalogNodes[i].catalogNodeId;
					}
					$scope.catalogNodes = catalogNodes;
					//Loading.run($scope.catalogNodes);
   			 }
   		})
	}

	// 切换视图
	$scope.fetchCatelog = function(id,event){
		if(id){ 
			var e = event.target,curr = angular.element(e);
			$(curr).parents('li').siblings('li').removeClass('curr');
			$(curr).parents('li').addClass('curr');
			$scope.cid = id;
			$ionicLoading.show({
				template: "正在载入数据，请稍后..."
			});
			$timeout(function(){
				getCatelogNodes($scope.cid);
				$ionicLoading.hide();
			},1000);
		}
		
	}
	
})
.controller('serviceInfoCtrl', function($scope,Locationer,$ionicModal,Api,$ionicLoading,$http,$stateParams) {
	$scope.goto = function(path){ 
		if(path){ 
			Locationer.next(path);
		}
	}
	
	var listId = $stateParams.id;
	// 获取参数列表
	Api.getApiData('get','service/queryServiceParameters/'+id)	
	.then(function(result) {
		console.log(result);
		if( result.desc.result_code && result.desc.result_code==200){ 
			
			
		}
	});
	// 创建参数模态窗口
	$ionicModal.fromTemplateUrl("params-modal.html", {
		scope: $scope,
		animation: "slide-in-up"
	}).then(function(modal) {
		$scope.modal = modal;
	});
	$scope.openModal = function() {
		$scope.modal.show();
	};
	$scope.closeModal = function() {
		$scope.modal.hide();
	};
	$scope.$on("$destroy", function() {
		$scope.modal.remove();
	});
	$scope.$on("modal.hidden", function() {
	});
	$scope.$on("modal.removed", function() {

	});
})
.controller('taskContentCtrl', function($scope,Locationer) {
    $scope.nextStep = function(path){ 
		if(path){ 
			Locationer.next(path);
		}
	}
})
.controller('mapBargainCtrl', function($scope,Locationer) {
  	$scope.goto = function(path){ 
		if(path){ 
			Locationer.next(path);
		}
	}
})
.controller('setTagsCtrl', function($scope,Locationer) {
  	$scope.goto = function(path){ 
		if(path){ 
			Locationer.next(path);
		}
	}
})
.controller('photosCtrl', function($scope,Locationer) {
  	$scope.goto = function(path){ 
		if(path){ 
			Locationer.next(path);
		}
	}
})
.controller('serviceDetailCtrl', function($scope) {

  	$scope.submit = function(){ 
		
	}
})
.controller('selectProperty', function($scope) {
  
})
.controller('templateListCtrl', function($scope,$http,Api,$stateParams,$ionicLoading,$location) {
   var catalogId = $stateParams.cid,catalogNodeId=  $stateParams.cnodeId;
   // 获取参数列表
	Api.getApiData('get','service/queryIndustryCatalog/'+catalogId)	
	.then(function(result) {
		var tempArr = {};
		if( result.desc.result_code && result.desc.result_code==200){ 
			var catalogNodes = result.data.catalogNodes;
	
			for(var i=0;i<catalogNodes.length;i++){ 
				if(catalogNodes[i].catalogNodeId==catalogNodeId){ 
					tempArr = catalogNodes[i].templateList;
				}
			}
			$scope.catalogNodes = tempArr;
			//console.log($scope.catalogNodes)
			
		}
	});

	$scope.goto = function(id){ 
		$location.path('serviceInfo/21110');
	}
})
