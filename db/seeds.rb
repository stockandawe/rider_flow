# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'
require 'csv'

route_tags = ["2","8X","KT","J"]
route_shape_id = {
  "2" => ["92376","92381"],
  "8X" => ["92408","92413"],
  "J" => ["92735","92735"],
  "KT" => ["92794","92804"]
}

route_tags.each do |route_tag|
  puts "Creating line #{route_tag}..."
  line = Line.create()

  # I am hosting interesting.html on a local server.  This is the URL.
  url_for_route_tag = "http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=sf-muni&r="+route_tag

  # Here we load the URL into Nokogiri for parsing downloading the page in
  # the process
  data = Nokogiri::XML(open(url_for_route_tag))
  # puts data
  root = data.root
  route = root.xpath('//route')

  # Read the title for this route
  line.name = "#{route.attr('title')}"
  line.save!

  stops = root.xpath('//route/stop')

  stops.each do |stop|
    stop = Stop.create(
      :tag => stop.attr('tag'),
      :title => stop.attr('title'),
      :stop_id => stop.attr('stopId'),
      :lat => stop.attr('lat'),
      :long => stop.attr('lon'),
      :riders => 0
    )
    stop.line = line
    stop.save!
  end

  url_for_buses_route_tag = "http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=sf-muni&r="+route_tag
  data = Nokogiri::XML(open(url_for_buses_route_tag))
  root = data.root
  buses = root.xpath('//vehicle')

  buses.each do |bus|
    bus = Bus.create(
      :bus_id => bus.attr('id'),
      :dir_tag => bus.attr('dirTag'),
      :lat => bus.attr('lat'),
      :long => bus.attr('lon'),
      :riders => 0
    )
    bus.line = line
    bus.save!
  end

  route = []
  CSV.foreach("#{Rails.root}/db/seed_data/shapes.csv") do |shapes|
    shape_id, lon, lat, seq, dist_travelled = shapes
    if (shape_id == route_shape_id[route_tag][0] or shape_id == route_shape_id[route_tag][1])
      route.append([lat, lon])
    end
  end
  line.route = route.to_s
  line.save!
end
