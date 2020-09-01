class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [:index, :loggedindex]
  def index
    @lobbies = Lobby.all
    @rooms = Room.all
    unless session[:user_id].nil?
      render :loggedindex
    end
    respond_to do |format|
      format.html 
      format.json
    end
  end

  def loggedindex
    @lobbies = Lobby.all
    @rooms = Room.all
    respond_to do |format|
      format.html 
      format.json
    end
  end
end
