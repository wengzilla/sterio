App.controller("PlaylistsController", ['$scope', 'playlistsFactory', 'tracksFactory', ($scope, playlistsFactory, tracksFactory) ->
  $scope.playlist = 1
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'

  init = () ->
    pubnubConnect()
    getPlaylist()

  pubnubConnect = ->
    $scope.pubnub_client = PUBNUB.init({publish_key: $scope.pubKey , subscribe_key: $scope.subKey});
    $scope.pubnub_client.subscribe {
      'channel': "playlist-#{$scope.playlist}"
      'callback': (data) =>
        if data?['action']
          getPlaylist(false)
    }

  getPlaylist = () ->
    playlistsFactory.getPlaylist($scope.playlist).then((response) ->
      $scope.tracks = response.data.tracks
    )

  $scope.removeTrack = (track, $event) ->
    tracksFactory.removeTrack($scope.playlist, track.id).then((response) ->
      $scope.tracks = response.tracks
    )

  init()
])