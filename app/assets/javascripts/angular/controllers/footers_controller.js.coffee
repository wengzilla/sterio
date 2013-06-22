App.controller("FootersController", ['$scope', '$location', '$routeParams', ($scope, $location, $routeParams) ->
  $scope.playlist = {id: $routeParams.id}

  $scope.showFooter = () ->
    $location.path() != "/" && window.isMobile()

  $scope.navigate = (path) ->
    $location.path("#{path}/#{$routeParams.id}")
])