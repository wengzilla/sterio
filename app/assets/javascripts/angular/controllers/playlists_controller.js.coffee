App.controller "PlaylistsController", ($scope, searchesFactory, tracksFactory) ->
  $scope.playlist = 1
  $scope.pubKey='pub-b0ec0cb4-6582-4e85-9c9e-1eae9873461a'
  $scope.subKey='sub-7c99adeb-fb9b-11e0-8d34-3773e0dc0c14'

  init = () ->
    tracksFactory.getTracks($scope.playlist).then((response) ->
      $scope.results = response.data
    )
    $scope.pubnub_client = PUBNUB.init({publish_key: $scope.pubKey , subscribe_key: $scope.subKey});
    $scope.connect()
  
  $scope.connect = ->
    $scope.pubnub_client.subscribe {
      'channel': "playlist-#{$scope.playlist}"
      'callback': (data) =>
        # action is like addTrack / removeTrack (false disables ajax request)
        console.log(data?['action'], data?['track'])
    }

  $scope.createTrack = (external_id) ->
    tracksFactory.createTrack($scope.playlist, external_id)

  init()
