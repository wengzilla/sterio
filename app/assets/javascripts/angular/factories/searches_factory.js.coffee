App.factory("searchesFactory", ['$http', ($http) ->
  factory = {}

  factory.getResults = (query, page=1) ->
    promise = $http({
      method: 'GET',
      url: 'api/v1/searches',
      params: {query: query, page: page}
    }).success((data) -> 
      data
    )
    promise

  factory
])