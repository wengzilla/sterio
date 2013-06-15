App.controller("PlayersController", ['$scope', 'playlistsFactory', 'tracksFactory', ($scope, playlistsFactory, tracksFactory) ->
  $scope.tracks = []
  $scope.playlist = {id: 1}
  $scope.shuffle = true
  $scope.sync    = true
  $scope.repeat = true
  $scope.showPlaylist = true

  $scope.shuffledTracks = [] # keeps a list of shuffled tracks

  $scope.playerState = ""
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'
  $scope.pubnub_client = PUBNUB.init({publish_key: $scope.pubKey , subscribe_key: $scope.subKey});
  $scope.pubnub_uuid = PUBNUB.uuid()

  yt = new YouTube

  # ========= BINDS ==========

  $(window).bind("videoReady", (e, p) => initPlayer(p))
  $(window).bind("playerStateChange", (e, s) => setPlayerState(s))

  $scope.$on '$destroy', () -> 
    $(window).unbind("videoReady")
    $(window).unbind("playerStateChange")
    pubnubDisconnect()

  # ========= WATCHERS =========

  $scope.$watch 'tracks', (o, n) -> shuffleTracks() if $scope.shuffle && o != n
  $scope.$watch 'shuffle', () -> shuffleTracks() if $scope.shuffle
  $scope.$watch 'sync', () -> console.log("sync on") if $scope.sync

  $scope.$watch 'playerState', (s) ->
    if s == "ENDED"
      $scope.nextVideo()

  $scope.$watch 'currentTrack', ->
    if $scope.currentTrack?
      $scope.playVideo($scope.currentTrack)
      $scope.pubnub_client.publish {
        channel: channelName(),
        message: { 'action':'playTrack', 'trackId': $scope.currentTrack.id, 'uuid': $scope.pubnub_uuid }
      }

  # ========= SCOPE METHODS =========

  $scope.setCurrentTrack = (track) ->
    $scope.currentTrack = track

  $scope.playVideo = (track=null) ->
    $(window).trigger("playVideo", track?.external_id)

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
    pubnubConnect()
    getPlaylist(true)
    $scope.player = p

  pubnubConnect = ->
    $scope.pubnub_client.subscribe
      'channel': channelName()
      'message': (data) =>
        if $scope.pubnub_uuid != data.uuid
          switch data?['action']
            when "addTrack" then getPlaylist(false)
            when "removeTrack" then removeTrack(data?['track'])
            when "playTrack"
              if data?['track']
                $scope.setCurrentTrack(data?['track'])
                $scope.$apply()
              else
                $scope.playVideo()
            when "pauseTrack" then $scope.stopVideo()
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
    "playlist-#{$scope.playlist.id}"

  publishInfo = () ->
    $scope.pubnub_client.publish {
      channel: channelName(),
      message: { 'action': 'publishInfo','state': $scope.playerState, 'trackId': $scope.currentTrack.id, 'uuid': $scope.pubnub_uuid }
    }

  getPlaylist = (setCurrentTrack = true) ->
    playlistsFactory.getPlaylist($scope.playlist.id).then((response) ->
      $scope.playlist = response.data
      $scope.tracks = $scope.playlist.tracks

      if setCurrentTrack
        index = if $scope.shuffle then _.first(_.shuffle([0...$scope.tracks.length])) else 0
        track = response.data.tracks[index]
        $scope.setCurrentTrack(track)
    )

  removeTrack = (track) ->
    if $scope.currentTrack.id == track.id then $scope.nextVideo()
    getPlaylist(false)

  setPlayerState = (s) ->
    $scope.playerState = s
    $scope.$apply()

  shuffleTracks = ->
    $scope.shuffledTracks = _.shuffle($scope.tracks)
])