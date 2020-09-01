class LobbiesController < ApplicationController
  before_action :set_lobby, only: [ :show, :edit, :update, :destroy]
  before_action :require_user
  skip_before_action :require_login, only: [:index, :show]

  # GET /lobbies
  # GET /lobbies.json
  def index
    @lobbies = Lobby.all.order(:applytime)
    respond_to do |format|
      format.html
      format.json {
        @lobbies = Lobby.where.not(applytime: nil) #= Lobby.where( 'applytime > ?', params[:my_applytime])
      }
    end
  end

  # GET /lobbies/1
  # GET /lobbies/1.json
  def show
    respond_to do |format|
      format.html
      format.json { @lobby }
    end
  end

  # GET /lobbies/new
  def new
    @lobby = Lobby.new
  end

  # GET /lobbies/1/edit
  def edit
  end

  # POST /lobbies
  # POST /lobbies.json
  def create
    @lobby = Lobby.new(lobby_params)

    respond_to do |format|
      if @lobby.save
        format.html
        format.json { render :show, status: :created, location: @lobby }
      else
        format.html { render :new }
        format.json { render json: @lobby.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lobbies/1
  # PATCH/PUT /lobbies/1.json
  def update
    respond_to do |format|
      if @lobby.update(lobby_params)
        format.html
        format.json { render :show, status: :ok, location: @lobby }
      else
        format.html { render :edit }
        format.json { render json: @lobby.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lobbies/1
  # DELETE /lobbies/1.json
  def destroy
    @lobby.destroy
    respond_to do |format|
      format.html { redirect_to lobbies_url, notice: 'Lobby was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lobby
      @lobby = Lobby.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lobby_params
      params.permit(:loginname, :applytime)
    end
end
