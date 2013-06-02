class Api::V1::SearchesController < Api::ApiController
  def index
    if params[:query].present?
      results = YoutubeParser.search(params[:query], params[:page], 20)
    else
    end
    render :json => results
  end
end