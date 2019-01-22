class User < ActiveRecord::Base

  has_many :tickets


  def create_user(name)

      User.create(:name name)

  end



end
