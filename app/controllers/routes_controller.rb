class RoutesController < ApplicationController

  def index
    

    p params
    
    if params[:search].present?
      imei = params[:search][:imei_text]
      imei = params[:search][:imei_select] if imei.blank?
    else
      imei = nil
    end

    p "imei: #{imei}"


    # получаем TDRы
    p @info = TimeDataRoute.search(params[:search], imei)
    # @info = nil

    # получаем точки для отображения на карте
    p data_points = Point.search(params[:search], imei)

    if data_points.present? && data_points.size > 0
      p @points = data_points
      p @points_map = @points.map{|x| {"lat" => x.lat, "lon" => x.lon}}.to_json

      p @begin_point = data_points.first
      p @end_point = data_points.last

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
    else
      respond_to do |format|
        format.js { render 'empty' }
        format.html
      end
    end
  end

end
