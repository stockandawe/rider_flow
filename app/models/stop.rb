class Stop < ActiveRecord::Base
  attr_accessible :lat, :long, :riders, :tag, :title, :stop_id
  belongs_to :line
end
