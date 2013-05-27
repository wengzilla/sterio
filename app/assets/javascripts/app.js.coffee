Util =
  pad2: (num) ->
    num = String(num)
    if num.length < 2 then "0#{num}" else num

angular.module('filters', [])
  .filter('time', -> (x) ->
    total = Math.floor(x)
    seconds = total % 60
    minutes = Math.floor((total % 3600) / 60)
    hours = Math.floor(total / 3600)
    if hours > 0
      "#{hours}:#{Util.pad2(minutes)}:#{Util.pad2(seconds)}"
    else
      "#{minutes}:#{Util.pad2(seconds)}")
  .filter "truncate", ->
    (text, length, end) ->
      if $(window).width() < 480
        length = 50
      else if $(window).width() < 1024
        length = 70
      else
        length = 1000

      end = "..."  if end is `undefined`
      if text.length <= length or text.length - end.length <= length
        text
      else
        String(text).substring(0, length - end.length) + end

window.App = angular.module('playerApp', ['filters', 'directives'])

window.onload = ->
  console.log "Test"
  setTimeout (->
    window.scrollTo 0, 1
  ), 100