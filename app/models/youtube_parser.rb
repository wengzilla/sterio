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
    data = {
      'duration' => video.duration,
      'external_source' => YoutubeParser.source,
      'external_author' => video.author.name,
      'external_id' => video.unique_id,
      'image' => video.thumbnails.first.url,
      'title' => video.title,
      'data' => video.to_json,
      'url' => "https://www.youtube.com/v/#{video.unique_id}"
    }

    track = Track.new(data)
  end

  def self.client
    @client ||= YouTubeIt::Client.new
  end

end