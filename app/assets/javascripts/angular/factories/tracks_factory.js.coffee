App.factory("tracksFactory", ['$http', ($http) ->
  factory = {}

  factory.createTrack = (playlist, external_id) ->
    promise = $http({
      method: 'POST',
      url: 'api/v1/tracks',
      data: { external_id: external_id, playlist: playlist }
    }).success((data) -> 
      data
    )
    promise

  factory.getTracks = (playlist) ->
    promise = $http({
      method: 'GET',
      url: 'api/v1/tracks',
      params: {playlist: playlist}
    }).success((data) -> 
      data
    )
    promise

  factory.removeTrack = (playlist, id) ->
    promise = $.ajax(
      url: "api/v1/tracks/#{id}",
      type: "POST",
      data: { playlist: playlist, '_method': 'DELETE' },
      success: (data) =>
        data
    )
    
  factory
])