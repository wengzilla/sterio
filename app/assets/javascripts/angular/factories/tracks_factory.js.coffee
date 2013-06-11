App.factory("tracksFactory", ['$http', ($http) ->
  factory = {}

  factory.createTrack = (playlist_id, external_id) ->
    promise = $http({
      method: 'POST',
      url: 'api/v1/tracks',
      data: { external_id: external_id, playlist_id: playlist_id }
    }).success((data) -> 
      data
    )
    promise

  factory.removeTrack = (playlist_id, id) ->
    promise = $.ajax(
      url: "api/v1/tracks/#{id}",
      type: "POST",
      data: { playlist_id: playlist_id, '_method': 'DELETE' },
      success: (data) =>
        data
    )
    
  factory
])