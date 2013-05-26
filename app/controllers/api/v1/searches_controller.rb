class Api::V1::SearchesController < Api::ApiController
  def index
    results = YoutubeParser.search(params[:query])
    render :json => results
  end
end