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

route_tag = "2"
line = Line.first_or_create(:name => "2-Clement")

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

ActiveRecord::Base.transaction do
  CSV.foreach("#{Rails.root}/db/seed_data/shapes.csv") do |shapes|
    shape_id, lon, lat, seq, dist_travelled = shapes
    # number, story_title, story_description, story_url, dont_use, story_date, story_org, story_fund, story_photo = orgs
# 
    # organization = Organization.find_by_name(story_org)
#    
    # if organization.present?
      # Story.where(title: story_title).first_or_create!(
        # content: story_description,
        # organization: organization,
        # slug: story_title.match(/(^[A-z0-9\s]*)/).to_s.downcase.gsub(/\s/,'_'),
        # photo_filename: story_photo,
        # published_at: story_date
      # )
    # else
      # message = "[Story Import] Could not find organization with name `#{story_org}'"
      # Rails.logger.warn message
      # puts message
    # end
  end
end