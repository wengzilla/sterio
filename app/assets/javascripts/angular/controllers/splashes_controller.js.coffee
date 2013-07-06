App.controller("SplashesController", ['$scope', '$location', ($scope, $location) ->
  $scope.showMobile = window.isMobile()

  $scope.navigate = () ->
    if $scope.playlist_id
      if $scope.showMobile
        $location.path("playlists/#{$scope.playlist_id}")
      else
        $location.path("players/#{$scope.playlist_id}")
])