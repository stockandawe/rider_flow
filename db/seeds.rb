# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'

route_tag = "1"
line = Line.create(:name => "1-California")

# I am hosting interesting.html on a local server.  This is the URL.
url_for_route_tag = "http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=sf-muni&r="+route_tag

# Here we load the URL into Nokogiri for parsing downloading the page in
# the process
data = Nokogiri::XML(open(url_for_route_tag))
root = data.root
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
