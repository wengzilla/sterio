App.controller("PlayersController", ['$scope', 'playlistsFactory', 'tracksFactory', ($scope, playlistsFactory, tracksFactory) ->
  $scope.tracks = []
  $scope.playlist = 1
  $scope.shuffle = true
  $scope.sync    = true
  $scope.repeat = true
  $scope.showPlaylist = true

  $scope.shuffledTracks = [] # keeps a list of shuffled tracks

  $scope.playerState = ""
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'

  $(window).bind("videoReady", (e, p) => initPlayer(p))
  $(window).bind("playerStateChange", (e, s) => setPlayerState(s))

  # ========= WATCHERS =========

  $scope.$watch 'tracks', (o, n) -> shuffleTracks() if $scope.shuffle && o != n
  $scope.$watch 'shuffle', () -> shuffleTracks() if $scope.shuffle
  $scope.$watch 'sync', () -> console.log("sync on") if $scope.sync

  $scope.$watch 'playerState', (s) ->
    if s == "ENDED"
      $scope.nextVideo()

  $scope.$watch 'currentTrack', (s) ->
    if $scope.currentTrack?
      $scope.playVideo($scope.currentTrack)

  # ========= SCOPE METHODS =========

  $scope.setCurrentTrack = (track) ->
    $scope.currentTrack = track

  $scope.playVideo = (track=null) ->
    $(window).trigger("playVideo", track?.external_id)

  $scope.stopVideo = ->
    $(window).trigger("stopVideo")

  $scope.removeTrack = (track, $event) ->
    tracksFactory.removeTrack($scope.playlist, track.id).then((response) ->
      $scope.tracks = response.tracks
    )

  $scope.nextVideo = (allowRepeat = true) ->
    videos = if $scope.shuffle then $scope.shuffledTracks else $scope.tracks

    # if the allowRepeat is set to true and there is only one video, play it again
    if allowRepeat and (videos.length == 1 || $scope.repeat == "loop-one")
      # haven't implemented loop-one yet....
      return $scope.playVideo()

    # if repeat is false and we are on the last track, do nothing.
    if $scope.repeat == false && $scope.currentTrack == _.last(videos)
      return $scope.stopVideo()

    index = (_.indexOf(videos, $scope.currentTrack) + 1) % videos.length
    index = 0 if index == -1
    console.log index
    $scope.setCurrentTrack(videos[index])

  initPlayer = (p) ->
    pubnubConnect()
    getPlaylist(true)
    $scope.player = p
    bindKeys()

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
        track = if response.data.current_track
          response.data.current_track
        else
          index = if $scope.shuffle then _.first(_.shuffle([0...$scope.tracks.length])) else 0
          response.data.tracks[index]

        $scope.setCurrentTrack(track)
    )

  setPlayerState = (s) ->
    $scope.playerState = s
    $scope.$apply()

  shuffleTracks = ->
    $scope.shuffledTracks = _.shuffle($scope.tracks)

  bindKeys = () ->
    $(document).keyup (e) ->
      code = if e.keyCode then e.keyCode else e.which
      if code == 39 # right arrow
        if not $(e.target).is('input')
          $scope.nextVideo(false)
          $scope.$apply()

  yt = new YouTube
])