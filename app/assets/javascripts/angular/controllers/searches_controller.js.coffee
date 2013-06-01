App.controller("SearchesController", ['$scope', 'searchesFactory', 'tracksFactory', ($scope, searchesFactory, tracksFactory) ->
  $scope.playlist = 1
  $scope.current_page = 1

  $scope.$watch 'query', (query) -> 
    $scope.current_page = 1
    $scope.search(query, $scope.current_page, true)

  $scope.search = (query, page=1, valueChanged=false) ->
    clearTimeout($scope.timeout)
    # Value changed is used to scroll back to the top before doing another
    # search. This way, we don't query twice if you go from a page with
    # 40 records to new search w/ 20 records. The 20 records needs the scroll
    # to move back to the top. 
    $('#results_container').scrollTop(0) if valueChanged && page == 1
    run = ->
      searchesFactory.getResults(query, $scope.current_page).then((response) ->
        if $scope.current_page == 1 || !$scope.tracks? #iPhone wasn't starting on page 1...
          $scope.tracks = response.data
        else
          $scope.tracks = $scope.tracks.concat(response.data)
        _bindInfiniteScroll()
      )
    $scope.timeout = setTimeout(run, 1000)

  init = () ->
    _bindInfiniteScroll()

  _bindInfiniteScroll = () ->
    # infinite scroll # ok
    results = $(document)
    _unbindInfiniteScroll()
    results.bind 'scroll', () ->
      if $(document).scrollTop() + $(window).height() >= $(document).height() - 200
        _unbindInfiniteScroll()
        $scope.current_page += 1
        $scope.search($scope.query, $scope.current_page)

  _unbindInfiniteScroll = () ->
    results = $(document)
    results.unbind 'scroll'

  $scope.createTrack = (track) ->
    tracksFactory.createTrack($scope.playlist, track.external_id)

  init()
])