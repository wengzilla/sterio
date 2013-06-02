class Api::V1::PlaylistsController < Api::ApiController
  def show
    if true
      render :json => playlist.to_json
    else
      render :json => false, :status => :unauthenticated
    end
  end

  private

  def playlist
    @playlist ||= Playlist.find_by_id(params[:id])
  end
end
