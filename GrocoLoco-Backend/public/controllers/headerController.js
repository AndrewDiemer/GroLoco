
GrocoLoco.controller('headerController', function($scope, $http, $location) {
	
	
	var partial = window.location.href.split('/#/')
	partial = partial[1]
	$scope.poop ='Navigation'

	if(partial=="analytics"){
		$("#analytics-tab").addClass('active')
		$("#store-builder-tab").removeClass('active')
		$("#grocery-manager-tab").removeClass('active')
		$("#promotions-tab").removeClass('active')

	} else if(partial==="store-builder"){
		$("#analytics-tab").removeClass('active')
		$("#store-builder-tab").addClass('active')
		$("#grocery-manager-tab").removeClass('active')
		$("#promotions-tab").removeClass('active')

	} else if(partial==="grocery-manager"){
		$("#analytics-tab").removeClass('active')
		$("#store-builder-tab").removeClass('active')
		$("#grocery-manager-tab").addClass('active')
		$("#promotions-tab").removeClass('active')

	}else if(partial==="promotions"){

		$("#analytics-tab").removeClass('active')
		$("#store-builder-tab").removeClass('active')
		$("#grocery-manager-tab").removeClass('active')
		$("#promotions-tab").addClass('active')

		// $("#data-dot-com-tab").removeClass('active')
		// $("#full-contact-tab").removeClass('active')
		// $("#rapportive-tab").removeClass('active')
		// $("#industry-search-tab").addClass('active')
		// $("#naics-lookup-tab").removeClass('active')
		// $("#industry-main-tab").addClass('open')
		// $("#search-tab").removeClass('active')

	}

	//URL Navigation
	$scope.analytics = function(){
		$location.path('/analytics')
	}
	$scope.storeBuilder = function(){
		$location.path('/store-builder')
	}
	$scope.rapportive = function(){
		$location.path('/rapportive')
	}
	$scope.groceryManager = function(){
		$location.path('/grocery-manager')
	}
	$scope.promotions = function(){
		$location.path('/promotions')
	}
	$scope.logout = function(){
		//Need to send request to logout
		$location.path('/')
		$http.post('/logout')
	}
})