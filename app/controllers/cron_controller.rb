class CronController < ApplicationController
  def riders
    Stop.all.each do |s|
      new_riders = -5 + rand(11)
      s.update_attribute(:riders, s.riders + (new_riders < 0 ? 0 : new_riders))
    end
    
    
    Bus.all.each do |b|
      new_riders = -5 + rand(11)
      b.update_attribute(:riders, b.riders + (new_riders < 0 ? 0 : new_riders))
    end
  end
end
