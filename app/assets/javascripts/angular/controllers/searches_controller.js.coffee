App.controller("SearchesController", ['$scope', 'searchesFactory', 'tracksFactory', ($scope, searchesFactory, tracksFactory) ->
  $scope.playlist = 1
  $scope.current_page = 1
  $scope.tracks = []

  $scope.$watch 'query', (query) ->
    $scope.current_page = 1
    $scope.search(query, $scope.current_page, true)

  $scope.$on '$destroy', () ->
    _unbindInfiniteScroll()

  window.searchCallback = (data) ->
    tracks = searchesFactory.formatYouTubeResults(data.feed.entry)

    if $scope.current_page == 1 || !$scope.tracks? #iPhone wasn't starting on page 1...
      $scope.tracks = tracks
    else
      $scope.tracks = $scope.tracks.concat(tracks)
      $scope.$apply()

    _bindInfiniteScroll()

  $scope.search = (query, page=1, valueChanged=false) ->
    clearTimeout($scope.timeout)
    # Value changed is used to scroll back to the top before doing another
    # search. This way, we don't query twice if you go from a page with
    # 40 records to new search w/ 20 records. The 20 records needs the scroll
    # to move back to the top. 
    $('#results_container').scrollTop(0) if valueChanged && page == 1
    run = ->
      searchesFactory.getYouTubeResults('videos', query, $scope.current_page)

    $scope.timeout = setTimeout(run, 300)

  init = () ->
    _bindInfiniteScroll()
    new StickyHeader(el) if el = $(".search-query").get(0)

  _bindInfiniteScroll = () ->
    # infinite scroll # ok
    scrollable = $(".search-results")
    _unbindInfiniteScroll()
    scrollable.bind 'scroll', () ->
      console.log "scrolling"
      if scrollable.scrollTop() + $(window).height() >= scrollable.get(0).scrollHeight
        console.log $scope.current_page
        _unbindInfiniteScroll()
        $scope.current_page += 1
        $scope.search($scope.query, $scope.current_page)

  _unbindInfiniteScroll = () ->
    $(".search-results").unbind 'scroll'

  $scope.createTrack = (track) ->
    tracksFactory.createTrack($scope.playlist, track.external_id)

  init()
])