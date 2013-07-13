App.controller("PlayersController", ['$scope', '$routeParams', 'playlistsFactory', 'tracksFactory', ($scope, $routeParams, playlistsFactory, tracksFactory) ->
  $scope.playlist = playlistsFactory.playlist()
  $scope.tracks = playlistsFactory.tracks()
  $scope.shuffle = true
  $scope.sync    = true
  $scope.repeat = true
  $scope.showPlaylist = true

  $scope.initialized = false # YouTube firing duplicate onPlayerReady events... Bug?
  $scope.shuffledTracks = [] # keeps a list of shuffled tracks

  $scope.playerState = ""
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'
  $scope.pubnub_client = PUBNUB.init({publish_key: $scope.pubKey , subscribe_key: $scope.subKey});
  $scope.pubnub_uuid = PUBNUB.uuid()
  $scope.playlistId = $routeParams.id

  yt = new YouTube

  # ========= BINDS ==========

  $(window).bind("videoReady", (e, p) => initPlayer(p))
  $(window).bind("playerStateChange", (e, s) => setPlayerState(s))
  $(window).bind("error", (e, p) => $scope.nextVideo(false); $scope.$apply())

  $scope.$on '$destroy', () -> 
    $(window).unbind("videoReady")
    $(window).unbind("playerStateChange")
    pubnubDisconnect()

  # ========= WATCHERS =========

  $scope.$watch 'playlist', (n, o) ->
    shuffleTracks() if $scope.shuffle && o != n
  , true
  $scope.$watch 'shuffle', () -> shuffleTracks() if $scope.shuffle
  $scope.$watch 'sync', () -> console.log("sync on") if $scope.sync

  $scope.$watch 'playerState', (s) ->
    if s == "ENDED"
      $scope.nextVideo()

  $scope.$watch 'currentTrack', ->
    if $scope.currentTrack?
      $scope.playVideo($scope.currentTrack)

  # ========= SCOPE METHODS =========

  $scope.setCurrentTrack = (track) ->
    $scope.currentTrack = track

  $scope.playVideo = (track=null) ->
    $(window).trigger("playVideo", track?.external_id)

  $scope.pauseVideo = ->
    $(window).trigger("pauseVideo")

  $scope.stopVideo = ->
    $(window).trigger("stopVideo")

  $scope.nextVideo = (allowRepeat = true) ->
    videos = if $scope.shuffle then $scope.shuffledTracks else $scope.tracks

    # if the allowRepeat is set to true and there is only one video, play it again
    if allowRepeat and (videos.length == 1 || $scope.repeat == "loop-one")
      # haven't implemented loop-one yet....
      return $scope.playVideo()

    # if repeat is false and we are on the last track, do nothing.
    if $scope.repeat == false && $scope.currentTrack == _.last(videos)
      return $scope.stopVideo()

    foundTrack = _.findWhere(videos, {id: $scope.currentTrack.id})
    index = (_.indexOf(videos, foundTrack) + 1) % videos.length
    $scope.setCurrentTrack(videos[index])

  initPlayer = (p) ->
    if $scope.initialized == false
      pubnubConnect()
      if _.isEmpty($scope.playlist) then getPlaylist() else playTrack()
      $scope.player = p
      $scope.initialized = true

  pubnubConnect = ->
    $scope.pubnub_client.subscribe
      'channel': channelName()
      'message': (data) =>
        if $scope.pubnub_uuid != data.uuid
          switch data?['action']
            when "addTrack" then getPlaylist()
            when "removeTrack" then removeTrack(data?['track'])
            when "playTrack"
              if data?['track']
                $scope.setCurrentTrack(data?['track'])
                $scope.$apply()
              else
                $scope.playVideo()
            when "pauseTrack" then $scope.pauseVideo()
            when "nextTrack"
              $scope.nextVideo(false)
              $scope.$apply()
            when "requestInfo"
              publishInfo()
            else console.log("PlayersController action not found: #{data['action']}")

  pubnubDisconnect = ->
    $scope.pubnub_client.unsubscribe
      'channel': channelName()

  channelName = () ->
    "playlist-#{$scope.playlistId}"

  publishInfo = () ->
    $scope.pubnub_client.publish {
      channel: channelName(),
      message: { 'action': 'publishInfo','state': $scope.playerState, 
      'trackId': $scope.currentTrack?.id, 'uuid': $scope.pubnub_uuid }
    }

  getPlaylist = () ->
    playlistsFactory.getPlaylist($scope.playlistId).then(() -> playTrack())

  playTrack = () ->
    if !$scope.currentTrack? && $scope.tracks
      index = if $scope.shuffle then _.first(_.shuffle([0...$scope.tracks.length])) else 0
      track = $scope.tracks[index]
      $scope.setCurrentTrack(track)

  removeTrack = (track) ->
    if $scope.currentTrack.id == track.id then $scope.nextVideo()
    getPlaylist()

  setPlayerState = (s) ->
    $scope.playerState = s
    $scope.$apply()
    publishInfo()

  shuffleTracks = ->
    $scope.shuffledTracks = _.shuffle($scope.tracks)
])