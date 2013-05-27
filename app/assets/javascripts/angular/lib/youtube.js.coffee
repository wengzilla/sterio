class window.YouTube
  constructor: ->
    @_addScriptTags()
    $(window).bind("playerReady", (e, p) => @_wireup(p))
    $(window).bind("videoStateChange", (e, p) => @_stateChange(p))
    $(window).bind("playVideo", (e, t) => @_playVideo(t))

  _addScriptTags: ->
    tag = document.createElement("script")
    tag.src = "https://www.youtube.com/iframe_api"
    firstScriptTag = document.getElementsByTagName("script")[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  _wireup: (p) ->
    @video_player = p
    $(window).trigger("videoReady")

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
        'onStateChange': onPlayerStateChange
      }
    })

  onPlayerReady = (event) ->
    player = event.target
    $(window).trigger("playerReady", player)

  onPlayerStateChange = (e) =>
    $(window).trigger("videoStateChange", e)

  videoPlayer = =>
    @video_player