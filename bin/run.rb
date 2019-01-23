 require_relative '../config/environment'
#!/usr/bin/env ruby
# require_all 'app'
require_relative '../lib/api_communicator.rb'
require_relative '../lib/command_line_interface.rb'


require_relative '../app/models/user.rb'
require_relative '../app/models/Ticket.rb'
require_relative '../app/models/Events.rb'



welcome
sign_in_welcome_page

main_menu
