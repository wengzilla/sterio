App.controller "SimpleController", ($scope, simpleFactory) ->
  $scope.customers = []

  init = () ->
    $scope.customers = simpleFactory.getCustomers()

  $scope.addCustomer = ->
    $scope.customers.push({ name: $scope.newCustomer.name, city: $scope.newCustomer.city })

  init()
