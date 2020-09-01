class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  private
    def require_user
      if(User.find_by(id: session[:user_id]).nil?)
        redirect_to '/'
      end
    end

  private
  def require_login
    if session[:user_id] == nil
      flash[:error] = "このページにアクセスするにはログインされている必要があります"
      redirect_to login_url # halts request cycle
    end
  end
end
