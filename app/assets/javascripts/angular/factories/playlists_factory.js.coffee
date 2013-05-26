App.factory("playlistsFactory", ['$http', ($http) ->
  factory = {}

  factory.getPlaylist = (playlist) ->
    promise = $http({
      method: 'GET',
      url: 'api/v1/playlists/' + playlist,
    }).success((data) -> 
      data
    )
    promise

  factory
])