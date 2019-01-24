require 'tty-table'
class User < ActiveRecord::Base

  has_many :tickets
  has_many :events, through: :tickets

  def self.create_user(name)
    user = User.find_by(name: name)
    if user
      puts ""
      puts "Welcome back #{name.capitalize}"
      user
    else
      puts ""
      puts 'User not found, please sign_up below'
      sign_up
      # User.create(name: name)
    end

  end

  def create_new_event_ticket(string)
    event_string = string.split(" -- ")
    name =  event_string[0].delete!("•")
    date =  event_string[1]
    venue =  event_string[2]

    # new_event = Event.create(event_name: name, date: date, venue: venue)
    new_event = Event.find_or_create_by(event_name: name, date: date, venue: venue)
    Ticket.create(user_id: self.id, event_id: new_event.id)
  end

  def view_saved_events
    #either find a list of instances saved events
    table = TTY::Table.new header: ['EVENTS','VENUES','DATES']
    # table << ["PINK","27th","02"]
    puts ""
    puts "Your upcoming events are: "
    puts ""
    self.reload.events.each do |event|
        # puts "------------EVENT--------------DATE-------------VENUE---------------"
        # puts "#{event.event_name} | #{event.date} | #{event.venue}"
         table << ["#{event.event_name[0..20]}", "#{event.venue[0..20]}", "#{event.date}"]
         table << ["----------------------","----------------------","----------------"]

        # puts table.render(:unicode, resize: true)
        # puts "-------------------"
    end
    puts table.render(:unicode)
    #or if none found prompts to search.
  end
end
