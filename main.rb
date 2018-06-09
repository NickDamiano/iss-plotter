require 'net/ssh'
require 'pry-byebug'

def write_points_txt(longitude, latitude, altitude)
	puts "Latitude is #{latitude}" 
	puts "Longitude is #{longitude}"
	puts "Altitude is #{altitude}"
	points = File.open("points.txt", 'a') 
		points.write " " + latitude  + ","
		points.write longitude + ","
		points.write altitude
		points.close
	sleep(5)
end

def write_kml
	IO.copy_stream('base.kml', 'final.kml')
	points_file = File.open("points.txt")
	points = points_file.readline
	points_file.close
	binding.pry
	file = File.open("final.kml", "a")
		# write points with proper tabbing
		# write the last few lines
	file.close
end

Net::SSH.start('192.168.254.27', 'adminuser', password: 'adminuser') do |ssh|
	# decide if you want to start with a fresh or keep old points
	input = ''
	until input == 'y' || input == 'n' do 
		puts "Do you want to continue your previous path?(y/n)"
		input = gets.chomp
		if input == 'n'
			points = File.open("points.txt", 'w')
		end
	end
	
	# final change this to a loop, change the points and altitude call for utstat -I | greps are the same
	1.times do 
		points = ssh.exec! 'cat Desktop/arinc_data.txt | grep ppos_lat'
		altitude_raw = ssh.exec! 'cat Desktop/inertial_altitude.txt | grep inertial_altitude'
		# assign lat, long, and altitude
		altitude_feet = altitude_raw.split(" ")[-1].to_i
		#convert to meters for google earth
		altitude_meters = (altitude_feet * 0.3048).to_i
		latitude = points.split(" ")[2].to_s
		longitude = points.split(" ")[-1].to_s 
		write_points_txt(latitude, longitude, altitude_meters)
		write_kml
	end
end



