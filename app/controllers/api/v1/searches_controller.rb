class Api::V1::SearchesController < Api::ApiController
  def index
    results = YoutubeParser.search(params[:query], params[:page], 20)
    render :json => results
  end
end