App.controller("SearchesController", ['$scope', 'searchesFactory', 'tracksFactory', ($scope, searchesFactory, tracksFactory) ->
  $scope.playlist = 1
  $scope.current_page = 1
  $scope.tracks = []
  $scope.showMobile = window.isMobile()

  $scope.$watch 'query', (query) ->
    $scope.current_page = 1
    $scope.search(query, $scope.current_page, true)

  $scope.$on '$destroy', () ->
    _unbindInfiniteScroll()

  window.searchCallback = (data) ->
    response = searchesFactory.formatYouTubeResults(data.feed.entry)
    _pushTracks(response)
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
      if query?
        searchesFactory.getYouTubeResults('videos', query, $scope.current_page)
      else
        searchesFactory.getTopItunesSongs($scope.current_page).then((response) ->
          _pushTracks(response.data)
          _bindInfiniteScroll()
        )
    $scope.timeout = setTimeout(run, 300)

  $scope.getNextPage = () ->
    $scope.current_page += 1
    console.log $scope.current_page
    $scope.search($scope.query, $scope.current_page)

  init = () ->
    _bindInfiniteScroll()

  _scrollable = () ->
    if $scope.showMobile then $(document) else $(".search-results")

  _shouldGetResults = () ->
    if $scope.showMobile
      # distance scrolled + window height >= total height of document
      _scrollable().scrollTop() + $(window).height() >= _scrollable().height() - 200
    else
      # distance scrolled in search results + window height >= total height of search results container
      _scrollable().scrollTop() + $(window).height() >= _scrollable().get(0).scrollHeight - 200

  _bindInfiniteScroll = () ->
    # infinite scroll # ok
    _unbindInfiniteScroll()
    _scrollable().bind 'scroll', () ->
      if _shouldGetResults()
        _unbindInfiniteScroll()
        $scope.getNextPage()

  _unbindInfiniteScroll = () ->
    _scrollable().unbind 'scroll'

  _pushTracks = (tracks) ->
    if $scope.current_page == 1 || !$scope.tracks? #iPhone wasn't starting on page 1...
      $scope.tracks = tracks
    else
      $scope.tracks = $scope.tracks.concat(tracks)

  $scope.createTrack = (track) ->
    tracksFactory.createTrack($scope.playlist, track.external_id)

  init()
])