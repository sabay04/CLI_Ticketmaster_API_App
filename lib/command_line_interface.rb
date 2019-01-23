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
      @city
    end

    def select_event_from_list(events)
      prompt = TTY::Prompt.new
      events = events.map{|event| event.values.join(" -- ")}
      events = events[0..19]
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
                puts "#{other_user.name.capitalize} will also be attending."
                puts "---------------------------"
              end

            end

            # User.find_by(User.events: @user.events)
            # logic
            # select * from users Where user.events == currentuser.events

          elsif selection == "Main menu"

              main_menu

          end


      end


    def main_menu


        prompt = TTY::Prompt.new
        selection = nil
        until selection == "Exit Program"
          #add "Switch city" "Filter search" "sign out"
          choice = ["Select from list of popular events in your area", "Saved events","Change city", "Sign out", "Exit Program"]
          selection = prompt.select("Please select from the menu:", choice)

          case selection

          # when "Select your city"
          #   city = get_location

          when "Select from list of popular events in your area"

            events = get_event_from_api(@city)
            selected_event = select_event_from_list(events)
              if selected_event == nil
                main_menu
              else
            @user.create_new_event_ticket(selected_event)
              end

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

          when "Exit Program"
            puts "Goodbye!"
             exit

          end
       end
    end
