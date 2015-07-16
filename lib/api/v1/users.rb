module API
  module V1
    require "http"
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
          present User.all.order(:updated_at)
        end

        put ':id' do
          User.find(params[:id]).update(
                      {
                        nick: params[:nick],
                        slogan: params[:slogan],
                        character_id: params[:character_id]
                      }
                  )

          present User.find(params[:id])
        end


        post :check_credentials do
          response = HTTP.headers(:accept => "application/json",
                                  :authorization => params["X-Verify-Credentials-Authorization"]).get(params["X-Auth-Service-Provider"])
          o = JSON.parse(response.body.readpartial)

          present User.find_or_create_by(:phone => o["phone_number"])
        end

        post :check_credentials_fix do
          present User.find_or_create_by(:phone => params["phone-number"])
        end
      end
    end
  end
end