class Itunes
  ITUNES_TOP_SONGS_KEY = "itunes_top_songs"

  def self.top_songs
    JSON.parse(REDIS.get(ITUNES_TOP_SONGS_KEY))
  end

  def self.get_top_songs(limit=200)
    url = "https://itunes.apple.com/us/rss/topsongs/limit=#{limit}/explicit=true/json"
    HTTParty.get(url).parsed_response["feed"]["entry"]
  end

  def self.set_top_songs(limit=200)
    songs = get_top_songs(limit)
    REDIS.set(ITUNES_TOP_SONGS_KEY, songs.map { |s| ItunesSong.new(s).save_to_redis }.to_json)
  end
end

class ItunesSong
  attr_accessor :song

  def initialize(song)
    @song = song
  end

  def title
    song["im:name"]["label"]
  end

  def external_id
    song["id"]["attributes"]["im:id"]
  end

  def key
    "itunes:#{external_id}"
  end

  def track_json
    Track.search_by_title(title).to_json
  end

  def save_to_redis
    track = REDIS.get(key).presence || REDIS.set(key, track_json)
    REDIS.expire(key, 1.week.seconds)
    JSON.parse(track)
  end
end
