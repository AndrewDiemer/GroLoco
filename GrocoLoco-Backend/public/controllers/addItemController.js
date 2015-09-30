//angular
Mean.controller('addItemController', function($scope, $http, $location) {
    $scope.submit = function() {
        
        console.log("adding item!");        
        
        var newItem = {
            itemName       : $('#itemName').val(),
            sku            : $('#sku').val(),
            locationID     : $('#locationID').val(),
        }

        $http.post('/newItem',newItem)
        .success(function(data, status) {
            console.log('successful post');
        }).error(function(status){
            console.log('failed post');
        });

    };
});