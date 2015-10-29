module API
  module V1
    require "http"
    class Users < Grape::API
      version 'v1'
      format :json

      resource :users do
        desc "Return a user."

        route_param :id do
          get do
            # User.find(params[:id])
            present User.find(params[:id])
          end
        end

        get do
          # present User.all.order(:updated_at)
          present User.ranking
        end

        put ':id' do
          User.find(params[:id]).update(
              {
                  :nick => params[:nick],
                  :slogan => params[:slogan],
                  :character_id => params[:character_id]
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

        post :login_facebook do

          @graph = Koala::Facebook::API.new(params[:token])
          @me = @graph.get_object("me", fields: ["id",
                                                 "first_name",
                                                 "last_name",
                                                 "email",
                                                 "picture",
                                                 "friends"])

          provider = UserProvider.find_or_create_by(:oauth_provider => "facebook",
                                                    :oauth_uid => params[:uid])
          provider.create_user({
                                   "first_name" => @me["first_name"],
                                   "last_name" => @me["last_name"],
                                   "email" => @me["email"],
                                   "picture" => @me["picture"]
                               }) if provider.user.nil?

          provider.save

          present provider.user
        end
      end
    end
  end
end