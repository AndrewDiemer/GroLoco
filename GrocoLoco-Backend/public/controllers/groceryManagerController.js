
GrocoLoco.controller('groceryManagerController', function($scope, $http, $location, $parse) {
	$scope.importData = ''

	 $scope.csv = {
    	content: null,
    	header: true,
    	headerVisible: true,
    	separator: ',',
    	separatorVisible: true,
    	result: null,
    	encoding: 'ISO-8859-1',
    	encodingVisible: true,
    };

    $('.label').css('color','black')

    $scope.importCSV = function(){
    	// console.log($scope.csv)
    	console.log($scope.importData)
    	console.log($scope.importData.length)
    	var List = {
    		List: $scope.importData
    	}
    	
    	$http.post('/massUpload', List).success(function(data,status){
    		console.log(data)
    		console.log(status)
    		alert('Successfully Uploaded ' + $scope.importData.length +' items!')
    	})
    	// console.log(toPrettyJSON)
    }

    var _lastGoodResult = '';
    $scope.toPrettyJSON = function (json, tabWidth) {
			var objStr = JSON.stringify(json);
			var obj = null;
			try {
				obj = $parse(objStr)({});
			} catch(e){
				// eat $parse error
				return _lastGoodResult;
			}

			var result = JSON.stringify(obj, null, Number(tabWidth));
			_lastGoodResult = result;
			$scope.importData = obj
			return result;
    };


	$scope.switchToDelete = function(){
		$('#delete').addClass('active')
		$('#add').removeClass('active')
		$('#upload').removeClass('active')
	}

	$scope.switchToAdd = function(){
		$('#add').addClass('active')
		$('#delete').removeClass('active')
		$('#upload').removeClass('active')
	}

	$scope.switchToUpload = function(){
		$('#add').removeClass('active')
		$('#delete').removeClass('active')
		$('#upload').addClass('active')
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