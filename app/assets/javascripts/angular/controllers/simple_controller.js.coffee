App.controller "SimpleController", ($scope, simpleFactory) ->
  $scope.entries = []

  $scope.$watch 'query', (query) ->
    simpleFactory.getSearchResults(query).then((data) -> console.log(data); $scope.results = data.data)

  init = () ->
    $scope.customers = simpleFactory.getCustomers()
    $scope.entries = simpleFactory.getEntries()

  $scope.addEntry = ->
    $scope.entries.push({ name: $scope.newEntry.name })

  $scope.draw = ->
    winner = _.first(_.shuffle($scope.entries))
    console.log(winner.name)

  init()
