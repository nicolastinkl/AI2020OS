angular.module('service.services', [])

.factory('Api', function($http, $q, ApiEndpoint) {
  var getApiData = function(method,params) {
    var q = $q.defer();

    $http({
        method:method,
        url : ApiEndpoint.url + params,
        cache:true,
    })
    .success(function(data) {
      q.resolve(data);
    })
    .error(function(error){
      q.reject(error);
    })
    return q.promise;
  }
  return {
    getApiData: getApiData
  };
})

.factory('Locationer', function($location) {
  var nextStep = function(path){ 
  		if(path){ 
  			$location.path(path);
  		}
  }
  return {
    next:nextStep
  };

})
