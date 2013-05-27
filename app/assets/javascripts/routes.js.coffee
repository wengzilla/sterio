App.config(['$routeProvider', ($routeProvider) -> 
  $routeProvider
    .when('/search',
    {
      controller: 'SearchesController',
      templateUrl: 'search' 
    })
    .when('/playlist',
    {
      controller: 'PlaylistsController',
      templateUrl: 'playlist'
    })
    .when('/player',
    {
      controller: 'PlayersController',
      templateUrl: 'player'
    })
    .otherwise({ redirectTo: '/search' })
])