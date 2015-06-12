WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:

  subscribe :client_connected, 'user#client_connected'
  namespace :duels do
    subscribe :start, 'duel#start'
    subscribe :index, 'duel#index'
  end
  namespace :users do
    subscribe :login, 'user#login'
    subscribe :index, 'user#index'
  end
end
