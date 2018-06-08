require 'net/ssh'
require 'pry-byebug'
require 'yaml'

def write_points_txt(longitude, latitude)
	puts "Latitude is #{latitude}"
	puts "Longitude is #{longitude}"
	points = File.open("points.txt", 'a') 
			points.write latitude  + ", "
			points.write longitude + ", "
			points.write 0
			points.write " "
			points.puts
			points.close
	sleep(2)
end

Net::SSH.start('192.168.254.27', 'adminuser', password: 'adminuser') do |ssh|
	# binding.pry
	5.times do 
		latitude = ssh.exec! 'cat Desktop/arinc_data.txt | grep "arincLatitude"'
		longitude = ssh.exec! 'cat Desktop/arinc_data.txt | grep "arincLongitude"'
		latitude = latitude.split(' ')[1]
		longitude = longitude.split(' ')[1]
		write_points_txt(longitude, latitude)
	end
end



