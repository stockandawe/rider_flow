class Stop < ActiveRecord::Base
  attr_accessible :lat, :long, :riders
  belongs_to :line
end
