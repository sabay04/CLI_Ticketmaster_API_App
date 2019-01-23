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
      city_name = prompt.select("Please select the city you'd like to search:", choices)
      puts "-------------------------------------------------------------------"
      city_name
    end

    def select_event_from_list(events)
      prompt = TTY::Prompt.new
      events = events.map{|event| event.values.join(" -- ")}
      events = events[0..19]
      # puts "Here's a list of the 10 most popular events in your location"
      # puts "*******************************************************************"
        choices = []

          events.map do |event|
          choices << "#{event}"
          end
          choices << "Back to main menu..."

          events.map { |event| choices << "#{event}" }


        puts "*****************************************************************"

        choice = prompt.select("Select the the event you'd like to attend: ", choices, per_page: 21)
          if choice == "Back to main menu..."
            main_menu
            return nil
          else
            choice
      end
    end

    def menu_flow
      # sign_in
      main_menu
    end



    def main_menu
      # username = get_user_name
      # user = User.create_user(username)

        prompt = TTY::Prompt.new
        selection = nil
        until selection == "Exit Program"
          choice = ["Select your city", "Select from list of popular events in your area", "View your saved events", "Exit Program"]
          selection = prompt.select("Please select from the menu:", choice)

          case selection

          when "Select your city"
            city = get_location

          when "Select from list of popular events in your area"
            events = get_event_from_api(city)
            selected_event = select_event_from_list(events)

            @user.create_new_event_ticket(selected_event)

          when "View your saved events"
            @user.view_saved_events

          when "Exit Program"
            puts "Goodbye!"

          end
       end
    end
