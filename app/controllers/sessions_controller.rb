class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  def new
    if session[:user_id] != nil
      redirect_to '/'
    end
  end

  def create
    @user = User.find_by(loginname: params[:loginname])
    if(@user&.authenticate(params[:password]))
      session[:user_id]=@user.id
      redirect_to login_url
    else
      redirect_to login_url, alert: 'ユーザ名かパスワードが間違っています'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end
end
