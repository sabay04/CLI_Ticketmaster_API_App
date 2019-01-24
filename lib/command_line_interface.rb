require 'tty-prompt'
require 'pry'
require 'artii'
require 'lolcat'
require 'progressbar'
require 'tty-table'
require "tty-spinner"
require 'tty-font'







  def user
    @user
  end

    def welcome
          system("clear")

              puts "Welcome to \n"
              puts  "--------------------------------------------------------------------- \n"
              system ("artii 'Sounds Good !' | lolcat -a -d 4")
              puts  "--------------------------------------------------------------------- \n"
              puts "The world's ONLY concert searching app®"
              puts ""
              puts "An app to find events in your area and add them to your diary"
          puts  "------------------------------------------------------------------- \n"



    end

    def get_user_name
        puts ""
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
              puts ""
              puts "Sorry this #{username.capitalize} has been taken. Please try again."
              sign_up
          else
              @user = User.create(name: username)
              puts ""
              puts "Welcome #{username.capitalize}, thank you for signing up to Sounds Good."
          end
        @user
    end

    def sign_in_welcome_page

      prompt = TTY::Prompt.new(active_color: :cyan)
      selection = nil

      choices = {"•Log in": 1, "•Sign up": 2}
      puts ""
      selection = prompt.select("Hello,Please pick and option:", choices)
        if selection ==  1
          log_in
        elsif selection == 2
          sign_up
        end
    end


    def get_location
      prompt = TTY::Prompt.new(active_color: :cyan)


      choices = ["London", "Dublin", "Manchester", "New York", "Miami","Los Angeles","Glasgow","Liverpool","Seattle","Sydney","Melbourne","Denver","Chicago","Toronto","Vancouver"].sort
      puts ""
      @city = prompt.select("Please select the city you'd like to search:", choices)
      puts ""
      puts "-------------------------------------------------------------------"
       # progressbar = ProgressBar.create(title: "Switching to #{@city}" )
       spinner = TTY::Spinner.new("Switching to #{@city} :spinner ", format: :arrow_pulse)
       spinner.auto_spin
       get_event_from_api(@city)
       spinner.stop
       # puts "Done!"

       # 30.times { progressbar.increment; sleep 0.03}
      @city
    end

    def select_event_from_list(events)
      if events == []
        puts ""
        puts "No matching events found"
          main_menu
          return nil
        else
      prompt = TTY::Prompt.new(active_color: :cyan)
      events = events.map{|event| event.values.join(" -- ")}
      # puts "Here's a list of the 10 most popular events in your location"
      # puts "*******************************************************************"
        choices = []

          events.map { |event| choices << "•#{event}" }
          choices << "•Back to main menu..."

        puts "-------------------------------------------------------------------"
        puts ""
        choice = prompt.select("Select the the event you'd like to attend: ", choices, per_page: 21)
          if choice == "•Back to main menu..."
            main_menu
            return nil
          else
            choice
        end
      end
    end

      def saved_events_menu
        table = TTY::Table.new header:['NAMES','EVENT']
        prompt = TTY::Prompt.new(active_color: :cyan)
        selection = nil

        choices = {"•View saved events": 1, "•Other users attending your events": 2,"•Remove saved events":3 ,"•Main menu": 4}
        puts ""
        selection = prompt.select("Choose an option below:", choices)

          if selection ==  1

              @user.view_saved_events

          elsif selection == 2
            puts "--------------------------------------------------------------"
            puts ""
            puts "other user attending your events:"

            (User.all - [@user]).select do |other_user|
              if !(other_user.events & @user.events).empty?

                @user.events.each do |current_user_event|
                  also_attending = other_user.events.select {|other_user_event| current_user_event == other_user_event}

                  also_attending.each do |other_event|

                    table << ["#{other_user.name.capitalize}","#{other_event.event_name[0..20]}"]
                    table << ["----------","--------------------"]

                    # attending = "#{other_user.name.capitalize} will also be attending #{other_event.event_name}."
                    # puts attending
                    # attending.length.times {print "-"}


                  end

                end
              end

            end

            puts table.render(:unicode)

          elsif selection == 3

            @user.remove_event

          elsif selection == 4

              main_menu

          end
      end


    def filter_menu(hash)
      # binding.pry
      prompt = TTY::Prompt.new(active_color: :cyan)
      choice = {"•By artist": 1, "•By date": 2 , "•By venue": 3, "•Main menu": 4}
      puts ""
      selection = prompt.select("Choose how you would like to filter", choice)

      case selection

      when 1
        puts ""
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

      when 2
        puts ""
        puts "Please enter the date in DD-MM-YYYY format"
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

      when 3
        puts ""
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

        when 4
          main_menu
      end
    end


    def main_menu


        prompt = TTY::Prompt.new(active_color: :cyan)
        selection = nil
        selected_event = nil
        until selection == 6
          #add "Switch city" "Filter search" "sign out"

          choice = {"•Poular events in your area": 1 , "•Filter event search": 2, "•Saved events": 3, "•Change city": 4, "•Sign out": 5 , "•Exit": 6}
          puts ""

          selection = prompt.select("Please select from the menu:", choice, )

          case selection

          # when "Select your city"
          #   city = get_location
          # when ""
          #   main_menu

        when 1

            selected_event = select_event_from_list(@event_array[0..19])
              if selected_event == nil
                main_menu
              else
                event_animation(selected_event)
                @user.create_new_event_ticket(selected_event)
              end

          when 2

              filter_menu(@event_array)


          when 3

            saved_events_menu

          when 4

              get_location

          when 5
            puts ""
            puts "Goodbye #{@user.name.capitalize}. You are now signed out."
            puts ""
            puts "--------------------------------------------"
            sign_in_welcome_page
            get_location


          when 6
            puts "Goodbye!"
             exit

          end
       end
    end


    def event_animation(event)
      font = TTY::Font.new(:standard)
          event_title = event.split("--")
          event_name = event_title[0].delete("•")
          event_name = event_name[0..20]
        puts ""
        puts "Congratulations #{@user.name.capitalize} you are attending:"

          if   event_name.length > 20
            system("artii '#{event_name.upcase} ...' | lolcat -a -d 2")
          else
            system("artii '#{event_name.upcase}' | lolcat -a -d 2")
          end
        # puts font.write("#{event_name.upcase}",letter_spacing: 2)

        puts "check saved events to view details and your other saved events"

    end
