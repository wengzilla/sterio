class Track < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  attr_accessible :data, :duration, :external_author, :external_id, 
                  :external_source, :image, :play_count, :title,
                  :url, :rating, :view_count, :playlist, :track, :user, :position

  belongs_to :playlist
  acts_as_list :scope => :playlist
  belongs_to :user

  # validates :user_id, :presence => true
  validates :playlist_id, :presence => true

  def as_json(*params)
    {
      "id" => self.id,
      "external_id" => self.external_id,
      "author" => self.external_author,
      "title" => self.title,
      "url" => self.url,
      "thumbnail_url" => self.image,
      "duration" => duration,
      "rating" => rating,
      "view_count" => view_count.to_s
    }
  end

  def self.search_by_title(title)
    YoutubeParser.search(title, 1, 1).first
  end

  def self.get_top_itunes_songs(page=1, limit=10)
    Itunes.top_songs[(page-1)*limit..(page*limit)-1]
  end

  after_create { publish('addTrack') }
  after_destroy { publish('removeTrack') }

  def publish(action)
    Messenger.send("playlist-#{playlist.id}", {
      :track => self.as_json,
      :action => action
    }) if playlist.present?
  end

end