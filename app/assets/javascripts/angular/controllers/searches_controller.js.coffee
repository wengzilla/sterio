App.controller("SearchesController", ['$scope', 'searchesFactory', 'tracksFactory', ($scope, searchesFactory, tracksFactory) ->
  $scope.playlist = 1
  $scope.current_page = 1

  $scope.$watch 'query', (query) -> 
    $scope.current_page = 1
    $scope.search(query, $scope.current_page, true)

  # infinite scroll # ok
  results = $(document)
  results.bind 'scroll', ->
    if results.scrollTop() + $(window).height() == results.height()
      $scope.current_page += 1
      console.log $scope.current_page
      $scope.search($scope.query, $scope.current_page)

  $scope.search = (query, page=1, valueChanged=false) ->
    clearTimeout($scope.timeout)
    # Value changed is used to scroll back to the top before doing another
    # search. This way, we don't query twice if you go from a page with
    # 40 records to new search w/ 20 records. The 20 records needs the scroll
    # to move back to the top. 
    $('#results_container').scrollTop(0) if valueChanged && page == 1
    run = ->
      searchesFactory.getResults(query, $scope.current_page).then((response) ->
        if $scope.current_page == 1
          $scope.tracks = response.data
        else
          $scope.tracks = $scope.tracks.concat(response.data)
      )
    $scope.timeout = setTimeout(run, 1000)

  init = () ->

  $scope.createTrack = (track) ->
    tracksFactory.createTrack($scope.playlist, track.external_id)

  init()
])