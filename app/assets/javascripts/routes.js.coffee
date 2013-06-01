App.config(['$routeProvider', ($routeProvider) -> 
  $routeProvider
    .when('/search',
    {
      templateUrl: 'partials/search'
    })
    .when('partials/playlist',
    {
      controller: 'PlaylistsController',
      templateUrl: 'partials/playlist'
    })
    .when('/player',
    {
      controller: 'PlayersController',
      templateUrl: 'partials/player'
    })
    .otherwise({ redirectTo: '/player' })
])