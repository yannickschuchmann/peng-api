class UserController < WebsocketRails::BaseController
  def client_connected
  end

  def login
    # digits signup, receive uid and phone number
    user = User.find_or_create_by({id: message[:user_id]}) # uid from digits
    connection_store[:user] = user
    WebsocketRails.users[user.id] = connection
    user.save
  end

  def index
    if message[:type] == "friends"
      # return friends
    else
      trigger_success ({users: User.all})
    end
  end
end
