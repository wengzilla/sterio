class Api::V1::TracksController < Api::ApiController
  def index
    if true #playlist.has_access?(current_user)
      render :json => playlist.ordered_tracks.to_json
    else
      render :json => false, :status => :unauthenticated
    end
  end

  def create
    track = YoutubeParser.parse(params[:external_id])

    if track# and playlist.can_edit?(current_user)
      # track.user = current_user
      track.playlist = playlist
      track.save!
      render :json => track, :status => 201
    else
      render :json => false, :status => 400
    end
  end

  def destroy
    track = playlist.tracks.find_by_url(params[:external_id])
    if track and playlist.can_edit?(current_user)
      render :json => playlist.track_indices.where(:track_id => track.id).delete_all
    else
      render :json => false
    end
  end

  private

  def playlist
    Playlist.find_by_id(params[:playlist]) || Playlist.new(:name => "Random Playlist")
  end
end
