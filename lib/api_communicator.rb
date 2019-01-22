require 'rest-client'
require 'json'
require 'pry'


def get_event_from_api(location)

 # puts "Please enter the name of the city"

 # city = gets.chomp.downcase

  response_string = RestClient.get("https://app.ticketmaster.com/discovery/v2/events.json?apikey=pQAHDQNADv3ILD6AiszHahtWnN3y3wN7&city=#{location}&size=100&classificationName=music")
  response_hash = JSON.parse(response_string)

        event_array = response_hash["_embedded"]["events"].map do |event|
          "#{event['name']} - #{event['dates']['start']['localDate']} - #{event['_embedded']['venues'][0]['name']}"
      end
      puts event_array[0..9]
    end

# get_event_from_api
