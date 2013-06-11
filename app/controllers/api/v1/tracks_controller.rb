class Api::V1::TracksController < Api::ApiController
  def index
    if true
      render :json => playlist.ordered_tracks.to_json
    else
      render :json => false, :status => :unauthenticated
    end
  end

  def create
    track = YoutubeParser.parse(params[:external_id])

    if track
      # track.user = current_user
      track.playlist = playlist
      track.save!
      render :json => track, :status => 201
    else
      render :json => false, :status => 400
    end
  end

  def destroy
    track = playlist.tracks.find(params[:id])
    if track && track.destroy
      render :json => {:tracks => playlist.tracks}
    else
      render :json => false
    end
  end

  private

  def playlist
    Playlist.find_by_id(params[:playlist_id]) || Playlist.new(:name => "Random Playlist")
  end
end
