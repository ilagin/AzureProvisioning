'use strict';
app.controller('homeController', ['$scope', 'authService', '$rootScope', function ($scope, authService, $rootScope) {
    $rootScope.pageHeader = "Home";
    $scope.authentication = authService.authentication;
}]);