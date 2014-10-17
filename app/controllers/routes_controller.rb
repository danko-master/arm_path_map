class RoutesController < ApplicationController

  def index
    # получаем TDRы
    @info = TimeDataRoute.search(params[:search])
    #@info = nil

    # получаем точки для отображения на карте
    data_points = Point.search(params[:search])

    #if params[:search]
      # сохраняем в куки последний запрос
    #  cookies[:date_from] = params[:search][:date_from]
    #  cookies[:date_to] = params[:search][:date_to]
    #end
    p @points = data_points[:points]
    p @points_map = @points.map{|x| {"lat" => x.lat, "lon" => x.lon}}.to_json

    p @begin_point = data_points[:begin_point]
    p @end_point = data_points[:end_point]

    if params[:search].blank?
      @points = []
      @points_map = []
      @info = nil
    end

    respond_to do |format|
      format.json { render :json => { tdrs: @info.to_json, points: @points } }
      format.js
      format.html
    end
  end

end
