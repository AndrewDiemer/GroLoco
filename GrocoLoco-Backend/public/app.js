 
 var GrocoLoco = angular.module('GrocoLoco', ['ngRoute', 'datatables', 'angularMoment', 'rzModule']);

 // configure our routes
 GrocoLoco.config(function($routeProvider) {

     $routeProvider
     .when('/', {
         templateUrl: 'views/home.html',
         controller: 'homeController'
     })
     .when('/login', {
         templateUrl: 'views/login.html',
         controller: 'loginController'
     })
     .when('/admin', {
         templateUrl: 'views/admin.html',
         controller: 'adminController'
     })
     .when('/analytics', {
         templateUrl: 'views/analytics.html',
         controller: 'analyticsController'
     })     

     .when('/store-builder', {
         templateUrl: 'views/store-builder.html',
         controller: 'storeBuilderController'
     })     

     .when('/grocery-manager', {
         templateUrl: 'views/grocery-manager.html',
         controller: 'groceryManagerController'
     })     

     .when('/promotions', {
         templateUrl: 'views/promotions.html',
         controller: 'promotionsController'
     })
    .otherwise({
        redirectTo: '/'
      });
 });
 
GrocoLoco.controller('mainController', function($scope) {
});

GrocoLoco.run(function(amMoment) {
    amMoment.changeLocale('est');
});


 GrocoLoco.constant('angularMomentConfig', {
    timezone: 'Canada/Toronto' // e.g. 'Europe/London'
});

 GrocoLoco.filter('category', function() {
    return function(category) {
        var categories = {
            0: 'Produce',
            1: 'Dairy',
            2: 'Deli',
            3: 'Frozen',
            4: 'Grains',
            5: 'Cans',
            6: 'Personal care',
            7: 'Bakery',
            8: 'Other'
        }
        return categories[category];
    };
});

  GrocoLoco.controller('mainController', function($scope, $rootScope, $location, $http) {
    $scope.$on('$routeChangeStart', function(event, currRoute, prevRoute){
        if(currRoute.$$route.templateUrl === 'views/analytics.html' || currRoute.$$route.templateUrl ==='views/grocery-manager.html' || currRoute.$$route.templateUrl ==='views/home.html' || currRoute.$$route.templateUrl ==='views/promotions.html' || currRoute.$$route.templateUrl ==='views/store-builder.html') {
            console.log('Check')
            $http.get('/loggedin').success(function(data,status){
                if(data.status == false)
                    $location.path('/login')
                else
                    console.log('proceed mister')
            }).error(function(data, status){
                console.log('YOUU SHALLL NOTTT PASSSS!!')
                $location.path('/login')
            })
        }else{
            console.log('No Check')
            console.log(currRoute.$$route.templateUrl)
        }
    })
 });