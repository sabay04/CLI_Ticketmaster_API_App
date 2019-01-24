require 'rest-client'
require 'json'
require 'pry'




def get_event_from_api(location)
  @event_array = []
  response_string = RestClient.get("https://app.ticketmaster.com/discovery/v2/events.json?apikey=pQAHDQNADv3ILD6AiszHahtWnN3y3wN7&city=#{location}&size=200&classificationName=music")
  response_hash = JSON.parse(response_string)
    # if response_hash["page"]["totalElements"] == 0
    #   puts "City not currently available for search, check back again soon!"
    # else

        response_hash["_embedded"]["events"].map do |event|
        @event_array <<  {name: event['name'], date: event['dates']['start']['localDate'].split("-").reverse.join("-"), venue: event['_embedded']['venues'][0]['name']}
        end
    # end

     #  event_array.uniq do |event|
     # event[:name] + event[:venue]
     # end
      i = 1
      while i < @event_array.length
        if @event_array[i][:date] == @event_array[i-1][:date] && @event_array[i][:venue] == @event_array[i-1][:venue]
          @event_array.slice!(i)
        end
        i+=1
      end
        @event_array
end
