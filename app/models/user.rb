class User < ActiveRecord::Base

  has_many :tickets
  has_many :events, through: :tickets

  def self.create_user(name)
    user = User.find_by(name: name)
    if user
      user
      puts "Welcome back #{name}"
    else
      puts 'User not found, creating new user!'
      User.create(name: name)
    end

  end

  def create_new_event_ticket(string)
    event_string = string.split("--")
    name =  event_string[0]
    date =  event_string[1]
    venue =  event_string[2]

    new_event = Event.create(event_name: name, date: date, venue: venue)
    Ticket.create(user_id: self.id, event_id: new_event.id)
  end

  def view_saved_events
    #either find a list of instances saved events
    self.events
    #or if none found prompts to search.

  end



end
