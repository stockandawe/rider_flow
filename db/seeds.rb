# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'nokogiri'
require 'open-uri'

# I am hosting interesting.html on a local server.  This is the URL.
url = "http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=sf-muni"

# Here we load the URL into Nokogiri for parsing downloading the page in
# the process
data = Nokogiri::XML(open(url))

root = data.root
puts data
routes = root.xpath("body/route")
puts routes.count
#puts data
