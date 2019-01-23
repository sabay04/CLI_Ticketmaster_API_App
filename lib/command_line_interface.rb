require 'tty-prompt'
require 'pry'

      def user
        @user
      end

    def welcome
          system("clear")
            puts "Welcome to Sounds Good! The world's ONLY concert searching app"
          puts  "-------------------------------------------------------------------"
    end

    def log_in
      username = get_user_name
      @user = User.create_user(username)
    end

    def sign_up

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


    def get_user_name
        puts "Please enter your name: "
        puts "-------------------------------------------------------------------"
        name = gets.chomp.downcase
        # puts "Hi #{name.capitalize} nice to meet you"
        puts "-------------------------------------------------------------------"

        name
    end


    def sign_in_welcome_page

      prompt = TTY::Prompt.new
      selection = nil

      choices = ["Log in", "Sign up"].sort
      selection = prompt.select("Hello:", choices)

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
      get_event_from_api(@city)
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

          events.map do |event|
          choices << "#{event}"
          end
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

    def menu_flow
      # sign_in
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



    def main_menu
      # username = get_user_name
      # user = User.create_user(username)

        prompt = TTY::Prompt.new
        selection = nil
        until selection == "Exit Program"
          #add "Switch city" "Filter search" "sign out"
          choice = ["Select from list of popular events in your area", "Search events in your area by artist, date or venue", "View your saved events", "Exit to main menu", "Logout", "Exit Program"]
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

          when "View your saved events"
            @user.view_saved_events

          when "Search events in your area by artist, date or venue"
            filter_menu(@event_array)

          when "Exit Program"
            puts "Goodbye!"
             exit

          end
       end
    end
