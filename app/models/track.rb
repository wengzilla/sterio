class Track < ActiveRecord::Base
  attr_accessible :data, :duration, :external_author, :external_id, 
                  :external_source, :image, :play_count, :title,
                  :url

  validates :external_id, :uniqueness => { :scope => :external_source }

  def as_json(*params)
    {
      "external_id" => self.external_id,
      "author" => self.external_author,
      'external_id' => self.external_id,
      "title" => self.title,
      'url' => self.url,
      "thumbnail" => {
        'url' => self.image
      },
      'video' => {
        'duration' => self.duration
      }
    }
  end
end