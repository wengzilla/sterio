App.controller("PlaylistsController", ['$scope', 'playlistsFactory', 'tracksFactory', ($scope, playlistsFactory, tracksFactory) ->
  $scope.playlist = {id: 1}
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'
  $scope.showMobile = window.isMobile()
  $scope.pubnub_uuid = PUBNUB.uuid()

  $scope.$on '$destroy', () -> 
    pubnubDisconnect()

  init = () ->
    pubnubConnect()
    getPlaylist()

  pubnubConnect = ->
    $scope.pubnub_client = PUBNUB.init({publish_key: $scope.pubKey , subscribe_key: $scope.subKey});
    $scope.pubnub_client.subscribe
      'channel': channelName()
      'connect': () =>
        getCurrentTrack()
      'message': (data) =>
        console.log data
        if $scope.pubnub_uuid != data.uuid
          switch data?['action']
            when "addTrack", "removeTrack" then getPlaylist(false)
            when "playTrack", "publishInfo"
              $scope.currentTrack = _.findWhere($scope.tracks, {id: data?['trackId']})
              $scope.currentTracks = [$scope.currentTrack]
              $scope.$apply()
            else console.log("Action not found.")

  pubnubDisconnect = ->
    $scope.pubnub_client.unsubscribe
      'channel': channelName()

  channelName = () ->
    "playlist-#{$scope.playlist.id}"


  getCurrentTrack = () ->
    $scope.pubnub_client.publish
      channel: channelName()
      message: { 'action': 'requestInfo', 'uuid': $scope.pubnub_uuid }

  getPlaylist = () ->
    playlistsFactory.getPlaylist($scope.playlist.id).then((response) ->
      $scope.tracks = response.data.tracks
    )

  $scope.sendAction = (action, track = null) ->
    $scope.pubnub_client.publish
      channel: channelName()
      message: { 'action': action, 'uuid': $scope.pubnub_uuid, 'track': track }

  $scope.removeTrack = (track, $event) ->
    # fast reject for display issues...
    $scope.tracks = _.reject($scope.tracks, (t) -> t.id == track.id)

    tracksFactory.removeTrack($scope.playlist.id, track.id).then((response) ->
      $scope.tracks = response.tracks
    )

  $scope.showCurrentVideo = () ->
    # console.log angular.isDefined($scope.currentTrack)
    # angular.isDefined($scope.currentTrack) && $scope.showMobile
    angular.isDefined($scope.currentTrack)

  init()
])