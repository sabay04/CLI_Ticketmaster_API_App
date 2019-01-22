class User < ActiveRecord::Base

  has_many :tickets


  def self.create_user(name)
    user = User.find_by(name: name)
    if user
      user
      puts "Welcome back #{name}"
    else
      puts 'User not found, creating new user!'
      User.create(name: name)
    end

  end

  def view_saved_events
    #either find a list of instances saved events

    #or if none found prompts to search.

  end



end
