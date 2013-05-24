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

  factory.createCustomer = (customer) ->
    customers

  factory
])