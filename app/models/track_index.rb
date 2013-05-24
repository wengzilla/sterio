class TrackIndex < ActiveRecord::Base
  attr_accessible :room, :track, :user, :position

  belongs_to :room
  acts_as_list :scope => :room

  belongs_to :track
  belongs_to :user

  validates :user_id, :presence => true
  validates :track_id, :presence => true, :uniqueness => { :scope => :room_id }
  validates :room_id, :presence => true
end
