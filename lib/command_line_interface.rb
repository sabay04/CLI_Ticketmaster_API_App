require 'tty-prompt'
require 'pry'
# require 'progressbar'
require 'artii'

  def user
    @user
  end

    def welcome
          system("clear")
            puts "Welcome to Sounds Good! The world's ONLY concert searching app"
          puts  "-------------------------------------------------------------------"
    end

    def get_user_name
        puts "Please enter your name: "
        puts "-------------------------------------------------------------------"
        name = gets.chomp.downcase
        # puts "Hi #{name.capitalize} nice to meet you"
        puts "-------------------------------------------------------------------"

        name
    end

    def log_in #if user already has a login otherwise it will send them to sign up
      username = get_user_name
      @user = User.create_user(username)
    end

    def sign_up  #first check if name entered is in users. if it is  then ask for another name if it isnt then save to users
          username = get_user_name
          if User.find_by(name: username)
              puts "Sorry this #{username.capitalize} has been taken. Please try again."
              sign_up
          else
              @user = User.create(name: username)
              puts "Welcome #{username.capitalize}, thank you for signing up to Sounds Good."
          end
        @user
    end

    def sign_in_welcome_page

      prompt = TTY::Prompt.new
      selection = nil

      choices = ["Log in", "Sign up"].sort
      selection = prompt.select("Hello,Please pick and option:", choices)
        if selection ==  "Log in"
          log_in
        elsif selection == "Sign up"
          sign_up
        end
    end


    def get_location
      prompt = TTY::Prompt.new
      choices = ["London", "Dublin", "Manchester", "New York"].sort
      @city = prompt.select("Please select the city you'd like to search:", choices)
      puts "-------------------------------------------------------------------"
        progressbar = ProgressBar.create(title: "Switching to #{@city}" )
      get_event_from_api(@city)
      30.times { progressbar.increment; sleep 0.03}
      @city
    end

    def select_event_from_list(events)
      if events == []
        puts "No matching events found"
          main_menu
          return nil
        else
      prompt = TTY::Prompt.new
      events = events.map{|event| event.values.join(" -- ")}
      # puts "Here's a list of the 10 most popular events in your location"
      # puts "*******************************************************************"
        choices = []

          events.map { |event| choices << "#{event}" }
          choices << "Back to main menu..."

        puts "*****************************************************************"

        choice = prompt.select("Select the the event you'd like to attend: ", choices, per_page: 21)
          if choice == "Back to main menu..."
            main_menu
            return nil
          else
            choice
        end
      end
    end

      def saved_events_menu

        prompt = TTY::Prompt.new
        selection = nil

        choices = ["View saved events", "Other users attending your events","Main menu"]
        selection = prompt.select("Choose an option below:", choices)

          if selection ==  "View saved events"

              @user.view_saved_events

          elsif selection == "Other users attending your events"
            puts "**********"
            puts "other user events:"

            (User.all - [@user]).select do |other_user|
              if !(other_user.events & @user.events).empty?

                @user.events.each do |current_user_event|
                  also_attending = other_user.events.select {|other_user_event| current_user_event == other_user_event}

                  also_attending.each do |other_event|
                    puts "#{other_user.name.capitalize} will also be attending #{other_event.event_name}."
                    puts "---------------------------"
                  end

                end
              end

            end

          elsif selection == "Main menu"

              main_menu

          end

    def filter_menu(hash)
      # binding.pry
      prompt = TTY::Prompt.new
      choice = ["By artist", "By date", "By venue", "Exit to main menu..."]
      selection = prompt.select("Choose how you would like to filter", choice)

      case selection

      when "By artist"
        puts "Please enter the name of the artist:"
          matching_events = []
          artist = gets.chomp
            hash.select do |event|
              if event[:name].include? artist
                matching_events << event
              end
           end
           event = select_event_from_list(matching_events)
             if event
               @user.create_new_event_ticket(event)
             end

      when "By date"
        puts "Please enter the date in YYYY-MM-DD format"
        matching_events = []
         date = gets.chomp
         hash.select do |event|
           if event[:date].include? date
             matching_events << event
           end
        end

        event = select_event_from_list(matching_events)
          if event
            @user.create_new_event_ticket(event)
          end

      when "By venue"
        puts "Please enter the name of the venue"
        matching_events = []
          venue = gets.chomp
          hash.select do |event|
            if event[:venue].include? venue
              matching_events << event
            end
         end
         event = select_event_from_list(matching_events)
           if event
             @user.create_new_event_ticket(event)
           end

        when "Exit to main menu..."
          main_menu
      end
    end


      end


    def main_menu


        prompt = TTY::Prompt.new
        selection = nil
        until selection == "Exit Program"
          #add "Switch city" "Filter search" "sign out"

          choice = ["Select from list of popular events in your area", "Search events in your area by artist, date or venue", "Saved events", "Change city", "Sign out", "Exit Program"]

          selection = prompt.select("Please select from the menu:", choice)

          case selection

          # when "Select your city"
          #   city = get_location

          when "Select from list of popular events in your area"

            selected_event = select_event_from_list(@event_array[0..19])
              if selected_event == nil
                main_menu
              else
            @user.create_new_event_ticket(selected_event)
              end

          when "Search events in your area by artist, date or venue"
            filter_menu(@event_array)
              filter_menu(@event_array)


          when "Saved events"

            saved_events_menu

          when "Change city"

              get_location

          when "Sign out"
            puts ""
            puts "Goodbye #{@user.name.capitalize}. You are now signed out."
            puts "--------------------------------------------"
            puts ""
            sign_in_welcome_page
            get_location


          when "Exit Program"
            puts "Goodbye!"
             exit

          end
       end
    end
