module API
  module V1
    class Duels < Grape::API
      version 'v1'
      format :json

      helpers do
        def create_duel(user_id, opponent_id, bet)
          actors = []
          actors << Actor.create(user_id: user_id, type: "challenger")
          opponent = Actor.create(user_id: opponent_id, type: "challengee")
          actors << opponent

          duel = Duel.new
          duel.bet = bet
          duel.actors << actors
          duel.save

          data = Duel::Entity.represent(duel, user_id: opponent.user_id)
          WebsocketRails.users[opponent.user_id].send_message "duels.challenged", data

          duel
        end
      end

      resource :duels do

        desc "Return a user."
        params do
          requires :id, type: Integer, desc: "duel id."
        end
        route_param :id do
          get do
            present Duel.find(params[:id]), user_id: params[:user_id].to_i unless params[:user_id].nil?
          end

          post do
            return unless params[:id]

            user_id = params[:user_id].to_i
            duel = Duel.find(params[:id].to_i)
            current_round = duel.rounds.last
            actor = duel.me? user_id
            if current_round.my_turn?(user_id) && actor
              action = Action.create(
                  round_id: current_round.id,
                  actor_id: actor.id,
                  type: params[:action_type]
              )

              opponent = duel.opponent? user_id

              data = Duel::Entity.represent(duel, user_id: opponent.user_id)
              WebsocketRails.users[opponent.user_id].send_message "duels.action_posted", data

              present Duel.find(params[:id].to_i), user_id: user_id
            else
              status 403
              {error: "already committed an action."}.as_json
            end

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