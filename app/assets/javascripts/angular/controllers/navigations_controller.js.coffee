App.controller("NavigationsController", ['$scope', '$location', '$routeParams', ($scope, $location, $routeParams) ->
  $scope.showNav = () ->
    $location.path() != "/"
])