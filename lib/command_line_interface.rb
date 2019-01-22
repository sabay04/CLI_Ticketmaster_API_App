

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


    def get_location
      puts "Please enter your city: "
      puts "-------------------------------------------------------------------"
      location = gets.chomp.downcase
      puts "-------------------------------------------------------------------"
      location
    end

    def select_event_from_list(events)
      events = events.map{|event| event.values.join(" -- ")}
      events = events[0..19]
      counter = 1
      puts "Here's a list of the 10 most popular events in your location"
      puts "*******************************************************************"
        events.map do |event|
          puts "#{counter}.  #{event}"
          counter +=1
          end
        puts "*****************************************************************"
        puts "Select the number of the event you'd like to attend: "
        selection = gets.chomp.to_i-1
        puts "Congratulations, you're going to #{events[selection]}"
        events[selection]
    end
