module API
  module V1
    class Characters < Grape::API
      version 'v1'
      format :json

      resource :characters do
        get do
          present Character.all
        end
      end
    end
  end
end