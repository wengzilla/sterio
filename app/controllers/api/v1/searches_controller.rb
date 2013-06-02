class Api::V1::SearchesController < Api::ApiController
  def index
    results = Track.get_top_itunes_songs(params[:page].to_i, params[:limit].to_i)
    render :json => results
  end
end