class Playlist < ActiveRecord::Base
  attr_accessible :description, :is_private, :name, :user_id, :token, 
                  :view_count, :user, :shared

  belongs_to :user
  uniquify :token

  belongs_to :current_track, :class_name => 'Track'
  has_many :tracks, :order => "position"

  validates :name, :presence => true, :length => { :maximum => 20 }
  # validates :user, :presence => true

  default_scope where(:active => true)

  def has_access?(user)
    !!(self.is_private ? user && self.user == user : true)
  end

  def can_edit?(user)
    user == self.user || (self.shared && user)
  end

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
end
