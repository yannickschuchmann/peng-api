class User < ActiveRecord::Base
  has_many :actors
  has_many :duels, through: :actors
  has_many :actions, through: :actors

  after_create :new_user

  def new_user
    WebsocketRails.users.each do |connection|
      connection.send_message "user.new", {users: User.all}
    end
  end

end
