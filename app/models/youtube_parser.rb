class YoutubeParser

  def self.parse(link)
    begin
      raise '' if link.blank?

      video = client.video_by(link)
      encode(video)
    rescue
      nil
    end
  end

  def self.search(terms, quantity=10)
    videos = client.videos_by(:query => terms, :per_page => quantity, :format => 5).videos
    videos.map do |video|
      encode(video)
    end
  end

  def self.source
    "YOUTUBE"
  end

  private

  def self.encode(video)
    data = Hash.new.tap do |hash|
      hash['duration'] = video.duration
      hash['external_source'] = YoutubeParser.source
      hash['external_author'] = video.author.name
      hash['external_id'] = video.unique_id
      hash['image'] = video.thumbnails.first.url
      hash['title'] = video.title
      hash['data'] = video.to_json
      hash['url'] = "https://www.youtube.com/v/#{video.unique_id}"
      hash['view_count'] = video.view_count
      hash['rating'] = (video.rating.average / video.rating.max * 100).round if video.rating
    end

    track = Track.new(data)
  end

  def self.client
    @client ||= YouTubeIt::Client.new
  end

end