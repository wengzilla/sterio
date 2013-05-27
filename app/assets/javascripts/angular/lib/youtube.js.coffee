class window.YouTube
  constructor: ->
    @_addScriptTags()
    $(window).bind("playerReady", (e, p) => @_wireup(p))
    $(window).bind("videoStateChange", (e, p) => @_stateChange(p))
    $(window).bind("playVideo", (e, t) => @_playVideo(t))
    $(window).bind("stopVideo", (e, t) => @_stopVideo(t))

  _addScriptTags: ->
    tag = document.createElement("script")
    tag.src = "https://www.youtube.com/iframe_api"
    firstScriptTag = document.getElementsByTagName("script")[0]
    firstScriptTag.parentNode.insertBefore tag, firstScriptTag

  _wireup: (p) ->
    window.test = p
    @video_player = p
    @_bindKeys()
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

  _bindKeys: () =>
    $(document).keyup (e) =>
      code = if e.keyCode then e.keyCode else e.which

      if code == 32 # spacebar
        if not $(e.target).is('input')
          # when spacebar is hit, the video should play/pause
          if @video_player.getPlayerState() == YT.PlayerState.PAUSED then @video_player.playVideo()
          else if @video_player.getPlayerState() == YT.PlayerState.PLAYING then @video_player.pauseVideo()

    $(document).keydown (e) => # pressing and holding keys will fire this multiple times.
      code = if e.keyCode then e.keyCode else e.which
      if code == 38 # up arrow
        if not $(e.target).is('input')
          @video_player.setVolume(@video_player.getVolume() + 10)

      if code == 40 # down arrow
        if not $(e.target).is('input')
          @video_player.setVolume(@video_player.getVolume() - 10)
