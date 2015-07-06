module API
  module V1
    class Users < Grape::API
      version 'v1'
      format :json

      resource :users do
        desc "Return a user."

        params do
          requires :id, type: Integer, desc: "user id."
        end
        route_param :id do
          get do
            # User.find(params[:id])
            present User.find(params[:id])
          end
        end

        get do
          present User.all
        end

        put ':id' do
          present User.find(params[:id]).update(
                      {
                        nick: params[:nick],
                        slogan: params[:slogan],
                        character_id: params[:character_id]
                      }
                  )
        end
      end
    end
  end
end