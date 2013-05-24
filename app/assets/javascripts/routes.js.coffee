App.config(($routeProvider) -> 
  $routeProvider
    .when('/',
    {
      controller: 'SimpleController',
      templateUrl: 'view1' 
    })
    .when('/partial2',
    {
      controller: 'SimpleController',
      templateUrl: 'view2'       
    })
    .otherwise({ redirectTo: '/' })
)