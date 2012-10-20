class Line < ActiveRecord::Base
  attr_accessible :name, :route
  has_many :stops
  has_many :buses
end
