'use strict';
app.factory('ordersService', ['$http', 'ngAuthSettings', function ($http, ngAuthSettings) {

    var serviceBase = ngAuthSettings.apiServiceBaseUri;

    var ordersServiceFactory = {};

    var _getOrders = function () {

        return $http.get(serviceBase + 'api/orders').then(function (results) {
            return results;
        });
    };

    var _createOrder = function (order) {
        var request = $http({
            method: "post",
            url: serviceBase + "api/orders/",
            data: order
        });

        return request;
    }

    ordersServiceFactory.getOrders = _getOrders;
    ordersServiceFactory.createOrder = _createOrder;

    return ordersServiceFactory;

}]);