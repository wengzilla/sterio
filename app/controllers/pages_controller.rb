class PagesController < ApplicationController
  protect_from_forgery
  include ContentNegotiation

  def index
  end
end
