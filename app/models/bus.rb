class Bus < ActiveRecord::Base
  attr_accessible :lat, :long, :riders, :bus_id, :dir_tag
  belongs_to :line
end
