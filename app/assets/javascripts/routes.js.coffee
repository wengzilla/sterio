App.config(['$routeProvider', ($routeProvider) -> 
  $routeProvider
    .when('/search',
    {
      templateUrl: 'partials/search'
    })
    .when('/playlist',
    {
      templateUrl: 'partials/playlist'
    })
    .when('/player',
    {
      controller: 'PlayersController',
      templateUrl: 'partials/player'
    })
    .otherwise({ redirectTo: if isMobile()
        console.log "I'm here"
        '/search'
      else
        '/player'})
])