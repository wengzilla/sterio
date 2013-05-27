App.controller "PlayersController", ($scope, playlistsFactory, tracksFactory) ->
  $scope.playlist = 1
  $scope.repeat = 0
  $scope.playerState = ""
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'

  $(window).bind("videoReady", (e, p) => initPlayer(p))
  $(window).bind("playerStateChange", (e, s) => setPlayerState(s))

  $scope.$watch 'playerState', (s) ->
    if s == "ENDED"
      $scope.nextVideo()
  $scope.$watch 'currentTrack', (s) ->
    if $scope.currentTrack?
      $scope.playVideo($scope.currentTrack)

  initPlayer = (p) ->
    pubnubConnect()
    getPlaylist(true)
    $scope.player = p

  pubnubConnect = ->
    $scope.pubnub_client = PUBNUB.init({publish_key: $scope.pubKey , subscribe_key: $scope.subKey});
    $scope.pubnub_client.subscribe {
      'channel': "playlist-#{$scope.playlist}"
      'callback': (data) =>
        if data?['action']
          getPlaylist(false)
    }

  getPlaylist = (setCurrentTrack = true) ->
    playlistsFactory.getPlaylist($scope.playlist).then((response) ->
      $scope.tracks = response.data.tracks

      if setCurrentTrack
        $scope.currentTrack = if response.data.current_track
          response.data.current_track
        else
          response.data.tracks[0]
    )

  setPlayerState = (s) ->
    $scope.playerState = s
    $scope.$apply()

  $scope.playVideo = (track = null) ->
    $(window).trigger("playVideo", track.external_id)

  $scope.removeTrack = (track, $event) ->
    tracksFactory.removeTrack($scope.playlist, track.id).then((response) ->
      $scope.tracks = response.tracks
    )

  $scope.nextVideo = (allowRepeat = true) ->
    videos = if $scope.shuffle then $scope.shuffled else $scope.tracks

    # if the repeat is set to 1 OR there is only one video, play it again
    if allowRepeat and ($scope.repeat == 1 || ($scope.repeat && videos.length == 1))
      return $scope.playVideo()

    # if repeat is false and we are on the last track, clear it
    if allowRepeat && $scope.repeat == false && $scope.currentTrack == _.last(videos)
      return $scope.clearVideo()

    index = _.indexOf($scope.tracks, $scope.currentTrack) + 1
    index = 0 if index == -1

    if index > videos.length - 1 then index = 0
    $scope.currentTrack = videos[index]

  yt = new YouTube
