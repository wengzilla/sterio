App.factory("simpleFactory", ['$http', ($http) ->
  customers = [
    { name: 'Edward Weng', city: 'MI' },
    { name: 'Michael Verdi', city: 'DC' },
    { name: 'Jeff Casimir', city: 'CO' },
    { name: 'Chris Maddox', city: 'SF' }
  ]

  factory = {}

  factory.getCustomers = () ->
    customers

  factory.getSearchResults = (query) ->
    promise = $http({
      method: 'GET',
      url: '/searches',
      params: {query: query}
    }).success((data) -> 
      console.log data
      data
    )
    promise

  factory.getEntries = () ->
    [ { name: "Ed" }, { name: "Jon" }, { name: "Verdi" } ]

  factory.createCustomer = (customer) ->
    customers

  factory
])