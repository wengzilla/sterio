App.controller("SplashesController", ['$scope', '$location', ($scope, $location) ->
  $scope.navigate = (path) ->
    if $scope.playlist_id
      $location.path("#{path}/#{$scope.playlist_id}")
])