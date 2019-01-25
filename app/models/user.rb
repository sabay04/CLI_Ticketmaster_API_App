require 'tty-table'
require 'tty-prompt'
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
      puts 'User not found, please sign up below'
      sign_up
      # User.create(name: name)
    end

  end

  def create_new_event_ticket(string)
    event_string = string.split(" -- ")
    name =  event_string[0].delete!("•")
    date =  event_string[1]
    venue =  event_string[2]

    new_event = Event.find_or_create_by(event_name: name, date: date, venue: venue)
    ticket = Ticket.find_by(user_id: self.id, event_id: new_event.id)
      if ticket
        puts "You're already attending this event!"
      else
        Ticket.create(user_id: self.id, event_id: new_event.id)
        event_animation(string)
      end
  end


  def view_saved_events
    #either find a list of instances saved events
    table = TTY::Table.new header: ['EVENTS','VENUES','DATES']
    # table << ["PINK","27th","02"]
    if self.events.length == 0
      puts ""
      puts "You don't have any saved events yet!"
    else


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
    end
    puts table.render(:unicode)
    #or if none found prompts to search.
    saved_events_menu
  end




  def remove_event
    binding.pry
    prompt = TTY::Prompt.new(active_color: :cyan)

    event_choice =[]


      self.reload.events.each do  |event_object|
        # binding.pry
        event_choice << "#{event_object.event_name} -- #{event_object.date} -- #{event_object.venue}"

      end

       event_choice << "•Main Menu"
       puts ""
       selection = prompt.select("Select the event you would like to remove: ", event_choice)

       if selection == "•Main Menu"
         main_menu


       else
         binding.pry
         event_attribute = selection.split(" -- ")
         name =  event_attribute[0]
         date =  event_attribute[1]
         venue = event_attribute[2]

         # new_event = Event.create(event_name: name, date: date, venue: venue)
         event = Event.find_by(event_name: name, date: date, venue: venue)

         Ticket.where(user_id: self.id, event_id: event.id).destroy_all
         puts ""
         puts "#{name} has been deleted from your saved events"
         remove_event
     end
   end
end
