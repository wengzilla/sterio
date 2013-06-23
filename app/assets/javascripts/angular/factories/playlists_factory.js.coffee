App.factory("playlistsFactory", ['$http', ($http) ->
  factory = {}
  tracks = []
  playlist = {}

  factory.playlist = () ->
    playlist

  factory.tracks = () ->
    tracks

  factory.getPlaylist = (id) ->
    promise = $http({
      method: 'GET',
      url: 'api/v1/playlists/' + id,
    }).success((response) ->
      angular.copy(response, playlist)
      angular.copy(response.tracks, tracks)
    )
    promise

  factory.createPlaylist = (params) ->
    promise = $http({
      method: 'POST',
      url: 'api/v1/playlists/'
      data: params,
    }).success((response) -> 
      data = response
    )
    promise

  factory
])