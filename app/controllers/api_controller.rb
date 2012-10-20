class ApiController < ApplicationController
  respond_to :json

  def lines
    respond_with Line.all
  end

  def line
    respond_with Line.find(params[:id])
  end

  def stops
    respond_with Line.find(params[:id]).stops
  end

  def stop
    respond_with Line.find(params[:id]).stops.find(params[:stop])
  end

  def buses
    respond_with Line.find(params[:id]).buses
  end

  def bus
    respond_with Line.find(params[:id]).buses.find(params[:bus])
  end

end
