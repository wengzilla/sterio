App.controller("SearchesController", ['$scope', 'searchesFactory', 'tracksFactory', ($scope, searchesFactory, tracksFactory) ->
  $scope.playlist = 1

  $scope.$watch 'query', (query) ->
    searchesFactory.getResults(query).then((response) ->
      $scope.results = response.data
    )

  init = () ->

  $scope.createTrack = (track) ->
    console.log("HERE")
    tracksFactory.createTrack($scope.playlist, track.external_id)

  init()
])