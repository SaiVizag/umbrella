# Write your solution below!
require "http"
require "json"
require "dotenv/load"
require "google_maps_service"
require "timezone"

# Initialize the timezone lookup
Timezone::Lookup.config(:geonames) do |config|
  config.username = 'saivizag' # Sign up at geonames.org for a free username
end

# Initialize the client
gmaps = GoogleMapsService::Client.new(key: 'gmaps_key')

puts "What is your address or location?"
user_location = gets.chomp
puts "Checking the weather and time at #{user_location}...."

gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_gmaps_data = HTTP.get(gmaps_url)
parsed_gmaps_data = JSON.parse(raw_gmaps_data)
results_array = parsed_gmaps_data.fetch("results")
first_result_hash = results_array.at(0)
geometry_hash = first_result_hash.fetch("geometry")
location_hash = geometry_hash.fetch("location")
latitude = location_hash.fetch("lat")
longitude = location_hash.fetch("lng")
puts "Your coordinates are #{latitude}, #{longitude}."

# Get the timezone for the coordinates
timezone = Timezone.lookup(latitude, longitude)
# Get the current time in the timezone
current_time = timezone.time(Time.now)
puts "The current time at the location is: #{current_time}"
