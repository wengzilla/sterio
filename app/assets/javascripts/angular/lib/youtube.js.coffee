class window.YouTube
  constructor: ->
    @_addScriptTags()
    $(window).bind("videoReady", (e, p) => @_wireup(p))
    $(window).bind("videoStateChange", (e, p) => @_stateChange(p))
    $(window).bind("playVideo", (e, t) => @_playVideo(t))

  _addScriptTags: ->
    tag = document.createElement("script")
    tag.src = "https://www.youtube.com/iframe_api"
    firstScriptTag = document.getElementsByTagName("script")[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  _wireup: (p) ->
    @video_player = p
    @_logActions()
    $(window).bind("videoGetCurrentTime", @_getCurrentTime)

  _logActions: =>
    # setInterval(@_getCurrentTime, 1000)
    
  _getCurrentTime: =>
    $(window).trigger("videoCurrentTime", @video_player.getCurrentTime())

  _stateChange: (e) =>
    if e.data is YT.PlayerState.ENDED
      console.log("ENDED")
    if e.data is YT.PlayerState.PLAYING 
      console.log("PLAYING")
    if e.data is YT.PlayerState.PAUSED
      console.log("PAUSED")
    if e.data is YT.PlayerState.BUFFERING
      console.log("BUFFERING")
    if e.data is YT.PlayerState.CUED
      console.log("CUED")

  _playVideo: (t) =>
    @video_player.loadVideoById(t)
    @video_player.playVideo()

  window.onYouTubeIframeAPIReady = =>
    console.log("HI")
    console.log $('#video_info').data('url')
    player = new YT.Player('ytplayer', {
      height: '295',
      width: '480',
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange
      }
    })

  onPlayerReady = (event) ->
    player = event.target
    $(window).trigger("videoReady", player)

  onPlayerStateChange = (e) =>
    $(window).trigger("videoStateChange", e)