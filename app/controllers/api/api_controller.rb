class Api::ApiController < ActionController::Base

  private

  def require_login
    if not current_user
      render :status => :unauthorized, :json => false
      false
    end
  end
end
