require 'nokogiri'
require 'open-uri'

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
    
    # update the bus coordinates from the feed
    route_tag = "2"
    url_for_buses_route_tag = "http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r="+route_tag
    data = Nokogiri::XML(open(url_for_buses_route_tag))
    root = data.root
    buses = root.xpath('//vehicle')
    
    buses.each do |bus|
      bus_id = bus.attr('id')
      b = Bus.find_by_bus_id(bus_id)
      b.update_attribute(:lat, bus.attr('lat'))
      b.update_attribute(:long, bus.attr('lon')) 
    end    
  end
end
