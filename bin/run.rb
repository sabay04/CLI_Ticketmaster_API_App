# require_relative '../config/environment'
#!/usr/bin/env ruby
require_relative '../lib/api_communicator.rb'
require_relative '../lib/command_line_interface.rb'


welcome
username = get_user_name
city = get_location
get_event_from_api(city)
