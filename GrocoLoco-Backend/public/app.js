 
 var GrocoLoco = angular.module('GrocoLoco', ['ngRoute']);

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