require 'net/http'
require 'json'
require 'pry-byebug'

def write_points_txt(longitude, latitude, altitude)
	puts "Longitude is #{longitude} - Latitude is #{latitude} - altitude is #{altitude} meters"
	points = File.open("points.txt", 'a') 
		points.write " " + latitude  + ","
		points.write longitude + ","
		points.write altitude
		points.close
	sleep(1)
end

def write_kml
	IO.copy_stream('base.kml', 'final.kml')
	points_file = File.open("points.txt")
	points = points_file.readline
	points_file.close
	file = File.open("final.kml", "a")
		file.puts "#{points}\n"
		file.puts "\t\t\t</coordinates>"
		file.puts "\t\t</LineString>"
		file.puts "\t</Placemark>"
		file.puts "</Document>"
		file.puts "</kml>"
	file.close
	puts "final.kml updated"
end

def get_aircraft_data
	# python api call to http://192.168.1.69:5001/AllAircraftPositions
	url 			= 'http://192.168.1.69:5001/AllAircraftPositions'
	uri 			= URI(url)
	response 		= Net::HTTP.get(uri)
	parsed_result = JSON.parse(response)
end


def run
	loop do
		aircraft_raw 	=  get_aircraft_data()
		altitude_feet 	= aircraft_raw[0]["altitude"].to_i
		altitude_meters = (altitude_feet * 0.3048).to_i
		latitude = aircraft_raw[0]["new_lat"].round(4).to_s
		longitude = aircraft_raw[0]["new_long"].round(4).to_s
		write_points_txt(longitude, latitude, altitude_meters)
		write_kml
	end
end

run



