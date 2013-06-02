App.factory("searchesFactory", ['$http', ($http) ->
  factory = {}
  callback = 'searchCallback'
  urlBase = "https://gdata.youtube.com/feeds/api/"
  count = 15;

  factory.getResults = (query, page=1) ->
    promise = $http({
      method: 'GET',
      url: 'api/v1/searches',
      params: {query: query, page: page}
    }).success((data) -> 
      data
    )
    promise

  factory.getYouTubeResults = (type='videos', query, page=1) ->
    unless query?
      url = urlBase + "standardfeeds/most_popular_Music?v=2&sort_by=top_favorites&time=today&start-index=" + page * count + "&max-results=" + count + "&safeSearch=none&v=2&alt=json&callback=" + callback;
    else
      url =  urlBase + type + "?q=" + query + "&start-index=" + page * count + "&max-results=" + count + "&safeSearch=none&v=2&alt=json&callback=" + callback;
    # callback parameter in URL will call window.searchCallback() on completion
    $http.jsonp(url)

  factory.formatYouTubeResults = (results) ->
    console.log results
    formattedResults = []
    for result in results
      formattedResults.push({
        'external_id': result.media$group?.yt$videoid?.$t,
        'author': result.author?[0]?.name?.$t,
        'title': result.title?.$t,
        'url': result.content?.src?.substring(0, result.content?.src?.indexOf('?')),
        'thumbnail_url': result.media$group?.media$thumbnail?[0]?.url,
        'duration': result.media$group?.yt$duration?.seconds,
        'rating': if result.gd$rating? then result.gd$rating?.average / result.gd$rating?.max * 100 else 0,
        'view_count': result.yt$statistics?.viewCount
      })
    formattedResults

  factory
])