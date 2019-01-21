require 'rest-client'
require 'json'
require 'pry'


def get_from_api

puts "Please enter the name of the artist"

artist = gets.chomp

 puts "Please enter the name of the city"

 city = gets.chomp

  response_string = RestClient.get("https://app.ticketmaster.com/discovery/v2/events.json?apikey=pQAHDQNADv3ILD6AiszHahtWnN3y3wN7&city=#{city}&size=10&classificationName=music")
  response_hash = JSON.parse(response_string)
      names = response_hash["_embedded"]["events"].map {|events| events["name"]}



    # response_hash.each do |key, value|
    #   puts key
    # end
    names.select do |name|
      if name.include?(artist)
        puts name
      end
    end
  end

get_from_api
