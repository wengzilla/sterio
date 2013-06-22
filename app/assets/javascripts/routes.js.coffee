App.config(['$routeProvider', ($routeProvider) -> 
  $routeProvider
    .when('/searches/:id',
    {
      templateUrl: 'partials/search'
    })
    .when('/playlists/:id',
    {
      templateUrl: 'partials/playlist'
    })
    .when('/players/:id',
    {
      controller: 'PlayersController',
      templateUrl: 'partials/player'
    })
    .when('/',
    {
      templateUrl: 'partials/splash'
    })
    .otherwise({ redirectTo: if isMobile()
        '/searches/:id'
      else
        '/'})
])