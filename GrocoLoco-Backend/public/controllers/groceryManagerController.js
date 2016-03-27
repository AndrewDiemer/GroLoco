
GrocoLoco.controller('groceryManagerController', function($scope, $http, $location) {
	$scope.list = function(){
		$('#grocery-list').addClass('active')
		$('#add').removeClass('active')
	}
})