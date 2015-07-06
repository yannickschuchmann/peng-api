module API
  module V1
    class Duels < Grape::API
      version 'v1'
      format :json

      helpers do
        def create_duel(user_id, opponent_id, bet)
          actors = []
          actors << Actor.create(user_id: user_id, type: "challenger")
          actors << Actor.create(user_id: opponent_id, type: "challengee")

          duel = Duel.new
          duel.bet = bet
          duel.actors << actors
          duel.save

          actors.each do |actor|
            WebsocketRails.users[actor.user.id].send_message "duel.challenged", {duel: duel}
          end
          return duel
        end
      end

      resource :duels do

        desc "Return a user."
        params do
          requires :id, type: Integer, desc: "duel id."
        end
        route_param :id do
          get do
            present Duel.find(params[:id])
          end
        end

        get do
          present Duel.all
        end

        params do
          requires :user_id, type: Integer, desc: "Challenger"
          requires :opponent_id, type: Integer, desc: "Challengee"
        end
        post do
          present create_duel(params[:user_id], params[:opponent_id], params[:bet])
        end

        params do
          requires :user_id, type: Integer, desc: "Challenger"
        end
        post :random do
          user_id = params[:user_id]
          opponent_id = User.where.not(id: user_id).limit(1).order("RANDOM()").first.id

          present create_duel(user_id, opponent_id, "")
        end
      end
    end
  end
end