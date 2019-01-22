 require_relative '../config/environment'
#!/usr/bin/env ruby
# require_all 'app'
require_relative '../lib/api_communicator.rb'
require_relative '../lib/command_line_interface.rb'


require_relative '../app/models/user.rb'
require_relative '../app/models/Ticket.rb'
require_relative '../app/models/Events.rb'



welcome
username = get_user_name
user = User.create_user(username)
city = get_location
events = get_event_from_api(city)
selected_event = select_event_from_list(events)
user.create_new_event_ticket(selected_event)
user.view_saved_events
