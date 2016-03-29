
GrocoLoco.controller('groceryManagerController', function($scope, $http, $location) {

	$scope.list = function(){
		$('#grocery-list').addClass('active')
		$('#add').removeClass('active')
	}

	$scope.createGroceryItem = function(){

		$http.get('/groceries').success(function(data, status){

			for( var i = 0; i<data.length; i++ ){
				if($scope.Description == data[i].Description){
					$scope.Description = "An item already exists with this name.";
					return;
				}
				else if($scope.Price == null){
					$scope.Description = "A valid price must be entered.";
					return;
				}
				else if($scope.Category == null){
					$scope.Description = "A category must be entered.";
					return;
				}
			}

			var item = {
				Category 	: $('#category').val(),
				Price		: $scope.Price,   
				Description : $scope.Description, 
				IconLink 	: $scope.IconLink
			}
				
			$http.post("/createGroceryItem", item).success(function(data,status){
			
				$scope.Price = ""; 
				$scope.Description = "";
				$scope.IconLink = "";
				$scope.Category = "";

				console.log(data);


			}).error(function(data, status){
			  	//something went wrong
			  	console.log(status)
			  	console.log(data)
			})

		})
			
	
	}
})