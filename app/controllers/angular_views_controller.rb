class AngularViewsController < ApplicationController
  protect_from_forgery

  def search
    render :layout => false
  end

  def playlist
    render :layout => false
  end

  def player
    render :layout => false
  end
end
