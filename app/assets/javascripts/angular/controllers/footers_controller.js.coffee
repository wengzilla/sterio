App.controller("FootersController", ['$scope', '$location', ($scope, $location) ->
  $scope.showFooter = () ->
    $location.path() != "/" && window.isMobile()
])