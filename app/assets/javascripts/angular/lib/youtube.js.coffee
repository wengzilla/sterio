class window.YouTube
  constructor: ->
    if $("#youtube_api").size() == 0
      @_addScriptTags()
      @_bindPlayerActions()
    else
      window.onYouTubeIframeAPIReady()

  _addScriptTags: ->
    tag = document.createElement("script")
    tag.id = "youtube_api"
    tag.src = "https://www.youtube.com/iframe_api"
    firstScriptTag = document.getElementsByTagName("script")[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  _bindPlayerActions: ->
    $(window).bind("playerReady", (e, p) => @_wireup(p))
    $(window).bind("videoStateChange", (e, p) => @_stateChange(p))
    $(window).bind("playVideo", (e, t) => @_playVideo(t))
    $(window).bind("stopVideo", (e, t) => @_stopVideo(t))

  _wireup: (p) ->
    @video_player = p
    $(window).trigger("videoReady", @video_player)

  _stateChange: (e) =>
    if e.data is YT.PlayerState.ENDED
      $(window).trigger("playerStateChange", "ENDED")
    if e.data is YT.PlayerState.PLAYING 
      $(window).trigger("playerStateChange", "PLAYING")
    if e.data is YT.PlayerState.PAUSED
      $(window).trigger("playerStateChange", "PAUSED")
    if e.data is YT.PlayerState.BUFFERING
      $(window).trigger("playerStateChange", "BUFFERING")
    if e.data is YT.PlayerState.CUED
      $(window).trigger("playerStateChange", "CUED")

  _playVideo: (t) =>
    if t? then @video_player.loadVideoById(t)
    @video_player.playVideo()

  _stopVideo: =>
    @video_player.stopVideo()

  window.onYouTubeIframeAPIReady = =>
    player = new YT.Player('ytplayer', {
      height: '100%',
      width: '100%',
      playerVars: {
        'origin': 'http://sterio.herokuapp.com',
        'modestbranding': 1,
        'rel': 0,
        'enablejsapi': 1,
        'color': 'white',
        'autohide': 2
      },
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange,
        'onError': onError
      }
    })

  onPlayerReady = (event) ->
    player = event.target
    $(window).trigger("playerReady", player)

  onPlayerStateChange = (e) =>
    $(window).trigger("videoStateChange", e)

  onError = (code) =>
    $(window).trigger("error", code.data)

  videoPlayer = =>
    @video_player
