module API
  class Root < Grape::API
    prefix 'api'

    error_formatter :json, API::ErrorFormatter

    mount API::V1::Root
  end
end