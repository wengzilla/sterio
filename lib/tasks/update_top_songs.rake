desc "Updates the top songs from the Itunes API"
task :update_top_songs  => :environment do
  Itunes.set_top_songs(300)
end
