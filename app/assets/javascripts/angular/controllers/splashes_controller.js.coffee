App.controller("SplashesController", ['$scope', '$location', 'playlistsFactory', ($scope, $location, playlistsFactory) ->
  $scope.showMobile = window.isMobile()

  $scope.navigate = () ->
    if $scope.playlist_id
      if $scope.showMobile
        $location.path("playlists/#{$scope.playlist_id}")
      else
        $location.path("players/#{$scope.playlist_id}")

  $scope.createPlaylist = () ->
    playlistsFactory.createPlaylist({'name': 'My Playlist'}).then((response) ->
      $scope.playlist_id = response.data.id
      $scope.navigate()
    )
])