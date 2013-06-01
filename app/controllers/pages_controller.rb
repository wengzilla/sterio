class PagesController < ApplicationController
  protect_from_forgery
  include ContentNegotiation

  def index
    # redirect_to mobile_path if is_device_request?
  end
end
