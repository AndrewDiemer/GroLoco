 
 var Mean = angular.module('Mean', ['ngRoute']);

 // configure our routes
 Mean.config(function($routeProvider) {

     $routeProvider
     .when('/', {
         templateUrl: 'views/login.html',
         controller: 'addItemController'
     })
     .when('/admin', {
         templateUrl: 'views/admin.html',
         controller: 'adminController'
     })
    .otherwise({
        redirectTo: '/'
      });
 });
 
 Mean.controller('mainController', function($scope) {
 });