App.factory("searchesFactory", ['$http', ($http) ->
  factory = {}

  factory.getResults = (query) ->
    promise = $http({
      method: 'GET',
      url: 'api/v1/searches',
      params: {query: query}
    }).success((data) -> 
      data
    )
    promise

  factory
])