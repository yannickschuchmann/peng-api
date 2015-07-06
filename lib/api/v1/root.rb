module API
  module V1
    class Root < Grape::API
      mount API::V1::Users
      mount API::V1::Duels
      mount API::V1::Characters
    end
  end
end