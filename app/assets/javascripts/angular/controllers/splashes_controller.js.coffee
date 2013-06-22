App.controller("SplashesController", ['$scope', '$location', ($scope, $location) ->
  $scope.changeView = () ->
    if $scope.playlist_id
      $location.path("/players/#{$scope.playlist_id}")
])