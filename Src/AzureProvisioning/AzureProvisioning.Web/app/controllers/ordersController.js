'use strict';
app.controller('ordersController', ['$scope', 'ordersService', '$rootScope', '$location', '$http', function ($scope, ordersService, $rootScope, $location, $http) {

    $rootScope.pageHeader = "Manage Orders";
    $scope.orders = [];
    $scope.order = {
                        isActive: true
                    }

    ordersService.getOrders().then(function (results) {
        $scope.orders = results.data;
    },
    function (error) {

    });

    $scope.newOrder = function () {
        $location.path("/orders/new");
    }

    $scope.saveOrder = function () {
        if ($scope.order.orderDetails.length > 0) {
            var promisse = ordersService.createOrder($scope.order);

            promisse.success(function(response, status, headers, config) {
                $location.path("/orders");
            });
            promisse.error(function(data, status, headers, config) {
                alert("failed to save order!");
            });
        }
    }
}]);