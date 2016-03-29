
GrocoLoco.controller('groceryManagerController', function($scope, $http, $location) {

	$scope.switchToDelete = function(){
		$('#delete').addClass('active')
		$('#add').removeClass('active')
	}

	$scope.switchToAdd = function(){
		$('#add').addClass('active')
		$('#delete').removeClass('active')
	}

	$http.get('/groceries').success(function(data, status){
		$scope.persons = data
	})

	$scope.deleteGroceryItem = function(item){
		console.log(item)
		$http.post('/deleteGroceryItem', item).success(function(data, status){
			console.log("success" + data)
			console.log(status)
			location.reload()
		}).error(function(data, status){
			console.log("Error" + data)
			console.log(status)
		})
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
			
				location.reload();
				console.log(data);


			}).error(function(data, status){
			  	//something went wrong
			  	console.log(status)
			  	console.log(data)
			})

		})
			
	
	}
})