

    def welcome

            puts "Welcome to Sounds Good! The worlds ONLY concert searching app"

          puts  "-------------------------------------------------------------------"

    end


    def get_user_name

        puts "Please enter your name"

        puts "-------------------------------------------------------------------"

        name = gets.chomp.downcase

        # puts "Hi #{name.capitalize} nice to meet you"

        puts "-------------------------------------------------------------------"

        name
    end


    def get_location

      puts "Please enter your city"
      puts "-------------------------------------------------------------------"
      location = gets.chomp.downcase
      puts "-------------------------------------------------------------------"

      location

    end
