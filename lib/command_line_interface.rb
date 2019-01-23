require 'tty-prompt'
require 'pry'

    def welcome
          system("clear")
            puts "Welcome to Sounds Good! The world's ONLY concert searching app"
          puts  "-------------------------------------------------------------------"
    end

    def log_in
      username = get_user_name
      user = User.create_user(username)
    end

    def sign_up

          username = get_user_name

          if User.find_by(name: username)


              puts "Sorry this #{username.capitalize} has been taken. Please try again."

               sign_up

          else

              user = User.create(name: username)
              puts "Welcome #{username.capitalize}, thank you for signing up to Sounds Good."
          end

          user
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
          events.map { |event| choices << "#{event}" }

        puts "*****************************************************************"

        prompt.select("Select the number of the event you'd like to attend: ", choices, per_page: 20)

        # selection = gets.chomp.to_i-1
        # puts "Congratulations, you're going to #{events[selection]}"
    end


   #  def main_menu
   #      prompt = TTY::Prompt.new
   #      selection = nil
   #      until selection = 6
   #        choice = ["Select your city", "View your saved events",  ]
   #
   #    case selection
   #
   #    when 12
   #      get_location
   #
   #    when 2
   #
   #
   #
   #
   #
   #
   #   end
   #
   # end
   #
   #
   #  end
