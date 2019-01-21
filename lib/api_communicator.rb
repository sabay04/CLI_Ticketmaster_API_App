require 'rest-client'
require 'json'
require 'pry'


def get_event_name_from_api

# puts "Please enter the name of the artist"
#
# artist = gets.chomp
#
#  puts "Please enter the name of the city"
#
#  city = gets.chomp

  response_string = RestClient.get("https://app.ticketmaster.com/discovery/v2/events.json?apikey=pQAHDQNADv3ILD6AiszHahtWnN3y3wN7&city=london&size=10&classificationName=music")
  response_hash = JSON.parse(response_string)

  response_hash["_embedded"]["events"].map do |event|
    puts "Artist:#{event['name']} ,Date: #{event['dates']['start']['localDate']}, Time: #{event['dates']['start']['localTime']}, Venue: #{event['_embedded']['venues'][0]['name']}, Post code: #{event['_embedded']['venues'][0]['postalCode']},City: #{event['_embedded']['venues'][1]['name']}, Genre: #{event['classifications'][0]['genre']['name']}"

      # names = response_hash["_embedded"]["events"].map {|events| events["name"]}
    # response_hash.each do |key, value|
    #   puts key


    end
  end

    # def search_by_name
    #    names.find do |name|
    #   if name.include?(artist)
    #     puts name
    #   end
    # end

get_event_name_from_api
