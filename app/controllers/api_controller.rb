class ApiController < ApplicationController
  respond_to :json
  
  def line
    @data = {
    }
    respond_with @data 

  end
  def stop
    @data = {
    }
    respond_with @data 

  end
  def bus
    @data = {
    }
    respond_with @data 

  end  
end
