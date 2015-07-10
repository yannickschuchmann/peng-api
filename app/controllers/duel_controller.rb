class DuelController < WebsocketRails::BaseController
  def start
    duel = Duel.new

    actors = []
    actors << Actor.create(user_id: message[:user_id], type: "challenger")
    actors << Actor.create(user_id: message[:opponent], type: "challengee")

    duel.actors << actors
    duel.save
    actors.each do |actor|
      WebsocketRails.users[actor.user.id].send_message "duels.challenged", {duel: duel}
    end
  end

  def index
    trigger_success ({duels: User.find(message[:user_id])
                                 .duels.as_json(include: [:actors, {:rounds => {include: :actions}}])})
  end


end
