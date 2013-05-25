class SearchesController < ApplicationController
  def index
    results = YoutubeParser.search(params[:query])
    render :json => results
  end
end