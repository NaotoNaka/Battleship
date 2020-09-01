class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:prepare, :battle]
  before_action :set_room_wo_id, only: [:prepare, :battle]
  skip_before_action :require_login, only: [:index, :show]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
    @field = params[:array]
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  def prepare
    @rooms = Room.all
    respond_to do |format|
      format.html
      format.json
    end
    '''
    #@coordinatesはx1,y1|x2,y2|
    if @coordinates==nil then
      @coordinates = ""
    end
    #それぞれの種類の船は置かれたか
    if @destroyerSet==nil then
      @destroyerSet = false
    end
    if @lightCruSet==nil then
      @lightCruSet = false
    end
    if @heavyCruSet==nil then
      @heavyCruSet = false
    end
    if @battleShipSet==nil then
      @battleShipSet = false
    end
    if @aircraftCarSet==nil then
      @aircraftCarSet = false
    end
    if @submarineSet==nil then
      @submarineSet = false
    end
    #フィールドを表す二次元配列(falseなら船を置いていない、trueなら船が置いてある)
    if @field==nil then
      @field = Array.new(10).map{Array.new(10, false)}
    end
    #URIから座標を得る(行,列)
    pos = params[:pos]
    #URIから艦の種類を得る
    type = params[:type]
    #URIから艦の向きを得る
    way = params[:way]

    #もし座標、艦の種類と艦の向きを指定していたら
    if pos!="" && pos!=nil && type!="" && type!=nil && way!="" && way!=nil then
      #文字列に変換
      pos = pos.to_s
      #座標から行と列を取り出す
      pAry = pos.split(",")
      row = pAry[0].to_i
      col = pAry[1].to_i

      #一旦個々の座標に分ける
      coorAry = @coordinates.split("|")
      #船は重なっていないか
      collision = false

      case type
      when "0", "1", "2", "3" then
        #駆逐艦、軽巡、重巡、戦艦の場合
        if way=="0" then
          #向きが縦なら
          (0..type.to_i+1).each do |i|
            #他の船と衝突していないか
            if coorAry.include?((row+i).to_s + "," + col.to_s) then
              collision = true
            end
          end
          #範囲内かつ衝突がなければ
          if row<(9-type.to_i) && !collision then
            (0..type.to_i+1).each do |i|
              @coordinates = @coordinates + (row+i).to_s + "," + col.to_s + "|"
            end
            #それぞれ押されたことを示す
            case type
            when "0" then
              @destroyerSet = true
            when "1" then
              @lightCruSet = true
            when "2" then
              @heavyCruSet = true
            when "3" then
              @battleShipSet = true
            end
          end
        else
          #向きが横なら
          (0..type.to_i+1).each do |i|
            if coorAry.include?(row.to_s + "," + (col+i).to_s) then
              collision = true
            end
          end
          #範囲内かつ衝突がなければ
          if col<(9-type.to_i) && !collision then
            (0..type.to_i+1).each do |i|
              @coordinates = @coordinates + row.to_s + "," + (col+i).to_s + "|"
            end
            case type
            when "0" then
              @destroyerSet = true
            when "1" then
              @lightCruSet = true
            when "2" then
              @heavyCruSet = true
            when "3" then
              @battleShipSet = true
            end
          end
        end
      when "4" then
        #空母の場合
        if way=="0" then
          (0..2).each do |i|
            if coorAry.include?((row+i).to_s + "," + col.to_s) then
              collision = true
            end
          end
          (0..2).each do |i|
            if coorAry.include?((row+1+i).to_s + "," + (col+1).to_s) then
              collision = true
            end
          end
          if row<7 && col<9 && !collision
            @coordinates = @coordinates + row.to_s + "," + col.to_s + "|" + (row+1).to_s + "," + col.to_s + "|" + (row+2).to_s + "," + col.to_s + "|" + (row+1).to_s + "," + (col+1).to_s + "|" + (row+2).to_s + "," + (col+1).to_s + "|" + (row+3).to_s + "," + (col+1).to_s + "|"
            @aircraftCarSet = true
          end
        else
          (0..2).each do |i|
            if coorAry.include?(row.to_s + "," + (col+i).to_s) then
              collision = true
            end
          end
          (0..2).each do |i|
            if coorAry.include?((row-1).to_s + "," + (col+1+i).to_s) then
              collision = true
            end
          end
          if row>0 && col<7 && !collision
            @coordinates = @coordinates + row.to_s + "," + col.to_s + "|" + row.to_s + "," + (col+1).to_s + "|" + row.to_s + "," + (col+2).to_s + "|" + (row-1).to_s + "," + (col+1).to_s + "|" + (row-1).to_s + "," + (col+2).to_s + "|" + (row-1).to_s + "," + (col+3).to_s + "|"
            @aircraftCarSet = true
          end
        end
      when "5" then
        #潜水艦の場合
        if way=="0" then
          (0..2).each do |i|
            if coorAry.include?((row+i).to_s + "," + col.to_s) then
              collision = true
            end
          end
          if coorAry.include?((row+1).to_s + "," + (col+1).to_s) then
            collision = true
          end
          if row<8 && col<9 && !collision then
            @coordinates = @coordinates + row.to_s + "," + col.to_s + "|" + (row+1).to_s + "," + col.to_s + "|" + (row+2).to_s + "," + col.to_s + "|" + (row+1).to_s + "," + (col+1).to_s + "|"
            @submarineSet = true
          end
        else
          (0..2).each do |i|
            if coorAry.include?(row.to_s + "," + (col+i).to_s) then
              collision = true
            end
          end
          if coorAry.include?((row-1).to_s + "," + (col+1).to_s) then
            collision = true
          end
          if row>0 && col<8 && !collision then
            @coordinates = @coordinates + row.to_s + "," + col.to_s + "|" + row.to_s + "," + (col+1).to_s + "|" + row.to_s + "," + (col+2).to_s + "|" + (row-1).to_s + "," + (col+1).to_s + "|"
            @submarineSet = true
          end
        end
      end
      #一旦個々の座標に分ける
      coorAry = @coordinates.split("|")
      #すべての座標に関して
      coorAry.each do |c|
        #行と列を取り出す
        posAry = c.split(",")
        #対応する位置の値を真にする
        @field[posAry[0].to_i][posAry[1].to_i] = true
      end
    end 
    '''
  end

  def battle
    @rooms = Room.all
    #自分の座標を表示
    if @myfield==nil then
      @myfield = Array.new(10).map{Array.new(10, 0)}
    end
    @myShipCoordinates = @room.myfield
    eachMyShipCoordinates = @myShipCoordinates.split("|")
    eachMyShipCoordinates.each do |e|
      myShipCoordinatesAry = e.split(",")
      @myfield[myShipCoordinatesAry[0].to_i][myShipCoordinatesAry[1].to_i] = 1
    end
    #opponent = @room.opponent
    oppoHits = @room.hits
    eachOppoHits = oppoHits.split("|")
    eachOppoHits.each do |e|
      oppoHitsAry = e.split(",")
      if @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]==1 then
        @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]=3
      elsif @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]==0 then
        @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]=2
      end
    end
    #相手の座標を取得
    if @hisfield==nil then
      @hisfield = Array.new(10).map{Array.new(10, 0)}
    end
    @hisroom = Room.find_by(loginname: @room.opponent)
    @hisShipCoordinates = (@hisroom).myfield
    eachHisShipCoordinates = @hisShipCoordinates.split("|")
    eachHisShipCoordinates.each do |e|
      hisShipCoordinatesAry = e.split(",")
      @hisfield[hisShipCoordinatesAry[0].to_i][hisShipCoordinatesAry[1].to_i] = 1
    end
    #me = @room.loginname
    myHits = (Room.find_by(loginname: @room.opponent)).hits
    eachMyHits = myHits.split("|")
    eachMyHits.each do |e|
      myHitsAry = e.split(",")
      if @hisfield[myHitsAry[0].to_i][myHitsAry[1].to_i]==1 then
        @hisfield[myHitsAry[0].to_i][myHitsAry[1].to_i]=3
      elsif @hisfield[myHitsAry[0].to_i][myHitsAry[1].to_i]==0 then
        @hisfield[myHitsAry[0].to_i][myHitsAry[1].to_i]=2
      end
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /rooms/1/edit
  def edit
    '''#自分のフィールドを表す二次元配列(0なら船を置いていない、1なら船が置いてある、2が当たっていない相手の攻撃、3が当たった相手の攻撃)
    if @myfield==nil then
      @myfield = Array.new(10).map{Array.new(10, 0)}
    end
    #以後自分のフィールドに船を配置する作業
    #自分のフィールドを読み込む
    @myShipCoordinates = Room.find(params[:id]).myfield
    #一旦個々の座標に分ける
    eachMyShipCoordinates = @myShipCoordinates.split("|")
    #すべての座標に関して
    eachMyShipCoordinates.each do |e|
      #行と列を取り出す
      myShipCoordinatesAry = e.split(",")
      #対応する位置の値を真にする
      @myfield[myShipCoordinatesAry[0].to_i][myShipCoordinatesAry[1].to_i] = 1
    end

    #以後自分の海域に相手の攻撃を反映させる
    #相手のユーザ名を取り出す
    opponent = Room.find(params[:id]).opponent
    #相手が指定した座標を取り出す
    oppoHits = Room.find_by(loginname: opponent).hits
    #一旦個々の座標に分ける
    eachOppoHits = oppoHits.split("|")
    #すべての座標に関して
    eachOppoHits.each do |e|
      #行と列を取り出す
      oppoHitsAry = e.split(",")
      #相手の攻撃が自分の船の座標にあたったか判定
      if @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]==1 then
        #もし当たったら
        @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]=3
      elsif @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]==0 then
        #もし当たらなかったら
        @myfield[oppoHitsAry[0].to_i][oppoHitsAry[1].to_i]=2
      end
    end

    #以後攻撃の機能
    #自分が攻撃する座標
    attackPos = params[:pos]
    #これまでのhitsを読み込む
    @myHits = Room.find(params[:id]).hits

    #相手のフィールドを表す二次元配列(0なら何もしていない海域、1なら相手の船に攻撃が当たった座標、2が当たらなかった攻撃の座標)
    if @oppoField==nil then
      @oppoField = Array.new(10).map{Array.new(10, 0)}
    end
    
    if (attackPos!=nil) then
      #行と列を取り出す
      attackPosAry = attackPos.split(",")
      #自分の攻撃する座標を記憶する
      @myHits =  @myHits + attackPosAry[0] + "," + attackPosAry[1] + "|"
    end

    #相手の船が置いてある座標
    oppoShipCoordinates = Room.find_by(loginname: opponent).myfield
    #一旦個々の座標に分ける
    eachMyHits = @myHits.split("|")
    #すべての座標に関して
    eachMyHits.each do |e|
      #行と列を取り出す
      myHitsAry = e.split(",")
      #自分の攻撃が相手の船の座標にあたったか判定
      if oppoShipCoordinates.include?(myHitsAry[0] + "," + myHitsAry[1]) then
        #もし当たったら
        @oppoField[myHitsAry[0].to_i][myHitsAry[1].to_i]=1
      else
        #もし当たらなかったら
        @oppoField[myHitsAry[0].to_i][myHitsAry[1].to_i]=2
      end
    end

    #勝敗判定
    @win = true
    @lose = true

    preMyHits = Room.find(params[:id]).hits
    
    #勝ちか判定
    #一旦個々の座標に分ける
    eachOppoShipCoordinates = oppoShipCoordinates.split("|")
    #すべての座標に関して
    eachOppoShipCoordinates.each do |e|
      #行と列を取り出す
      oppoShipCoordinatesAry = e.split(",")
      if !preMyHits.include?(oppoShipCoordinatesAry[0] + "," + oppoShipCoordinatesAry[1]) then
        #もし自分が攻撃した座標に相手の船の座標が含まれていなかったら偽になる
        @win = false
      end
    end

    #負けか判定
    #一旦個々の座標に分ける
    eachMyShipCoordinates = @myShipCoordinates.split("|")
    #すべての座標に関して
    eachMyShipCoordinates.each do |e|
      #行と列を取り出す
      myShipCoordinatesAry = e.split(",")
      if !oppoHits.include?(myShipCoordinatesAry[0] + "," + myShipCoordinatesAry[1]) then
        #もし相手が攻撃した座標に自分の船の座標が含まれていなかったら偽になる
        @lose = false
      end
    end

    
    respond_to do |format|
      format.html 
      format.json {@field = params[:array]}
    end'''
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html 
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    #@coordinates = nil
    #@destroyerSet = nil
    #@lightCruSet = nil
    #@heavyCruSet = nil
    #@battleShipSet = nil
    #@aircraftCarSet = nil
    #@submarineSet = nil
    #@field = nil
    
    respond_to do |format|
      if @room.update(room_params)
        format.html 
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    def set_room_wo_id
      @room = Room.find_by(loginname: User.find(session[:user_id]).loginname)
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.permit(:loginname, :opponent, :myfield, :hits)
    end
end
