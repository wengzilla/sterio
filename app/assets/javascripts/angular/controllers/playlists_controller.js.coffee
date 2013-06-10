App.controller("PlaylistsController", ['$scope', 'playlistsFactory', 'tracksFactory', ($scope, playlistsFactory, tracksFactory) ->
  $scope.playlist = {id: 1}
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'
  $scope.showMobile = window.isMobile()
  $scope.pubnub_uuid = PUBNUB.uuid()

  init = () ->
    pubnubConnect()
    getPlaylist()

  pubnubConnect = ->
    $scope.pubnub_client = PUBNUB.init({publish_key: $scope.pubKey , subscribe_key: $scope.subKey});
    $scope.pubnub_client.subscribe {
      'channel': "playlist-#{$scope.playlist.id}"
      'connect': () =>
        getCurrentTrack()
      'callback': (data) =>
        if $scope.pubnub_uuid != data.uuid
          switch data?['action']
            when "addTrack", "removeTrack" then getPlaylist(false)
            when "playTrack", "publishInfo"
              $scope.currentTrack = _.findWhere($scope.tracks, {id: data?['trackId']})
              $scope.$apply()
            else console.log("Action not found.")
    }

  getCurrentTrack = () ->
    $scope.pubnub_client.publish {
      channel: "playlist-#{$scope.playlist.id}",
      message: { 'action': 'requestInfo', 'uuid': $scope.pubnub_uuid }
    }

  getPlaylist = () ->
    playlistsFactory.getPlaylist($scope.playlist.id).then((response) ->
      $scope.tracks = response.data.tracks
    )

  $scope.sendAction = (action) ->
    $scope.pubnub_client.publish {
      channel: "playlist-#{$scope.playlist.id}",
      message: { 'action': action, 'uuid': $scope.pubnub_uuid }
    }

  $scope.removeTrack = (track, $event) ->
    tracksFactory.removeTrack($scope.playlist, track.id).then((response) ->
      $scope.tracks = response.tracks
    )

  $scope.showCurrentVideo = () ->
    $scope.currentTrack? && $scope.showMobile

  init()
])