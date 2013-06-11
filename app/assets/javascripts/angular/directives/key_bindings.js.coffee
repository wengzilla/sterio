module = angular.module('keyBindings', [])

module.directive 'playerKeyBindings', () ->
  (scope, element, attr) ->
    keyUpFunction = (e) ->
      if not $(e.target).is('input')
        code = if e.keyCode then e.keyCode else e.which
        switch code
          when 39 # right arrow
            scope.nextVideo(false)
            scope.$apply()
          when 32 # spacebar
            # when spacebar is hit, the video should play/pause
            if scope.player.getPlayerState() == YT.PlayerState.PAUSED then scope.player.playVideo()
            else if scope.player.getPlayerState() == YT.PlayerState.PLAYING then scope.player.pauseVideo()

    keyDownFunction = (e) ->
      if not $(e.target).is('input') && not $(e.target).is('.video-list')
        code = if e.keyCode then e.keyCode else e.which
        switch code
          when 38 # up arrow
            scope.player.setVolume(scope.player.getVolume() + 10)
          when 40 # down arrow
            scope.player.setVolume(scope.player.getVolume() - 10)

    # bind the keyUpFunction for playerController
    $(document).keyup keyUpFunction
    $(document).keydown keyDownFunction

    # unbind the keyUpFunction for playerController on destroy
    scope.$on '$destroy', () ->
      $(document).unbind("keyup", keyUpFunction)
      $(document).unbind("keydown", keyDownFunction)