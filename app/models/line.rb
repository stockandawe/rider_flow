class Line < ActiveRecord::Base
  attr_accessible :name, :route
  has_many :stops, :buses
end
