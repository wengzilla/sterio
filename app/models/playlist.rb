class Playlist < ActiveRecord::Base
  attr_accessible :description, :name, :user_id, :token, 
                  :view_count, :user

  belongs_to :user

  belongs_to :current_track, :class_name => 'Track'
  has_many :tracks, :order => "position"

  validates :name, :presence => true, :length => { :maximum => 20 }
  # validates :user, :presence => true
  validates_uniqueness_of :token, :case_sensitive => false
  before_validation :generate_token, :on => :create

  def ordered_tracks
    tracks
    # sort_order == "DESC" ? tracks.reverse : tracks
  end

  def increment_view_count
    self.view_count ||= 0
    self.view_count += 1
    self.save
  end

  def as_json(options={})
    params = {
      # :url => Rails.application.routes.url_helpers.playlist_path(token),
      :current_track => current_track,
      :tracks => tracks
    }
    super().merge(params)
  end

  def random_token
    ('a'..'z').to_a.sample(3).join
  end

  def generate_token
    if token.nil?
      temp_token = random_token
      begin
        self.token = temp_token
      end until Playlist.where(:token => temp_token).count == 0
    end
  end
end
