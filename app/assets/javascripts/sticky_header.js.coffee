class @StickyHeader
  constructor: (@el) ->
    if $('#app-info').data('mobile')
      @$el = $ @el
      offset = @$el.offset().top

      $(window).scroll =>
        if @_sticky(offset)
          @$el.addClass("sticky")
          @_setWidth()
        else
          @$el.removeClass("sticky")

      $(window).resize =>
        if @_sticky(offset)
          @_setWidth()

  _setWidth: =>
    @$el.css('width', $("body").width())

  _sticky: (offset) =>
    $(window).scrollTop() > offset