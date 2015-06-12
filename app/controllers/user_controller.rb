class UserController < WebsocketRails::BaseController
  def client_connected
  end

  def login
    # digits signup, receive uid and phone number
    user = User.find_or_create_by({id: message[:user_id]}) # uid from digits
    user.phone = "01234" # digits phone

    connection_store[:user] = user
    WebsocketRails.users[user.id] = connection

    # create/update user session token => {uid, expired}
    trigger_success ({token: 789})
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
