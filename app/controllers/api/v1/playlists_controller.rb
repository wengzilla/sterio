class Api::V1::PlaylistsController < Api::ApiController
  def create
    playlist = Playlist.new(params[:playlist])

    if playlist.save
      render :json => playlist.to_json
    else
      render :json => playlist.errors.full_messages
    end
  end

  def show
    if true
      render :json => playlist.to_json
    else
      render :json => false, :status => :unauthenticated
    end
  end

  private

  def playlist
    @playlist ||= (Playlist.find_by_id(params[:id]) || Playlist.where("lower(token) = ?", params[:id].downcase).first)
  end
end
