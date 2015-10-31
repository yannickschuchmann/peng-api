class Duel < ActiveRecord::Base
  has_many :actors, dependent: :destroy
  has_many :users, through: :actors
  has_many :rounds, dependent: :destroy
  has_many :actions, through: :rounds

  after_create :setup_rounds

  def setup_rounds
    first_round = Round.create(rid: 0, active: true, duel_id: self.id)
    self.actors.each do |actor|
      action = Action.create(
          round_id: first_round.id,
          actor_id: actor.id,
          type: "neutral"
      )
    end
  end

  def end_of_round round
    # self.actors.each do |actor|
    #   data = Entity.represent(self, user_id: actor.user_id.to_i, type: :end_of_round)
    #   WebsocketRails.users[actor.user_id].send_message "duel.end_of_round", data.as_json
    # end

    if self.winner
      self.winner.user.duels_won_count += 1
      self.winner.user.save
      return
    end

    Round.create(rid: self.rounds.length, duel_id: self.id, active: true)
  end

  def last_active_round
    self.rounds.where(active: false).order(:rid).last
  end

  def winner
    self.actors.each_with_index do |actor, index|
      return self.actors[(index - 1).abs] if actor.hit_points == 0
    end
    return false
  end

  def status user_id
    if (winner = self.winner)
      if winner.user_id == user_id
        "won"
      else
        "lost"
      end
    elsif self.my_turn? user_id
      "my_turn"
    else
      "wait"
    end
  end

  def result? user_id
    status = status(user_id)
    current_round = self.rounds.last
    if self.rounds.finished.length == 1 && current_round.get_user_action(user_id) == nil
      'versus'
    elsif status == 'my_turn'
      result_type = self.last_active_round.get_result['type']
      if result_type == 'reloaded'
        if self.last_active_round.get_user_action(user_id).type == 'neutral'
          result_type = 'you_reloaded'
        else
          result_type = 'enemy_reloaded'
        end
      end
      result_type
    elsif status == 'wait'
      type = self.rounds.last.get_user_action(user_id).type
      if type == 'offensive'
        'you_shoot'
      elsif type == 'defensive'
        'you_block'
      elsif type == 'neutral'
        'you_reload'
      end
    else
      "you_#{status}"
    end
  end

  def my_turn? user_id
    self.rounds.last.my_turn? user_id unless self.rounds.empty?
  end

  def bet_default
    self.bet == "" ? "random duel" : self.bet
  end

  def me? user_id
    self.actors.each do |actor|
      return actor if actor.user_id == user_id
    end
  end

  def opponent? user_id
    self.actors.each do |actor|
      return actor if actor.user_id != user_id
    end
  end

  def my_action? user_id
    self.last_active_round.actions.each do |action|
      return action if action.actor.user_id == user_id
    end unless self.last_active_round.nil?
    return false
  end

  def opponent_action? user_id
    self.last_active_round.actions.each do |action|
      return action if action.actor.user_id != user_id
    end unless self.last_active_round.nil?
    return false
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :bet_default, as: :bet
    expose :me, with: Actor::Entity do |duel,options|
      duel.me?(options[:user_id]) if options[:user_id]
    end
    expose :opponent, with: Actor::Entity do |duel,options|
      duel.opponent?(options[:user_id]) if options[:user_id]
    end
    expose :my_turn do |duel,options|
      duel.my_turn?(options[:user_id]) if options[:user_id]
    end
    expose :status do |duel,options|
      if options[:user_id]
        status = duel.status(options[:user_id])
        case status
          when "won" then "YOU WON"
          when "lost" then "YOU LOST"
          when "my_turn" then "YOUR TURN!"
          when "wait" then "WAITING ..."
        end
      end
    end
    expose :my_action do |duel,options|
      duel.my_action?(options[:user_id]) if options[:user_id]
    end
    expose :opponent_action do |duel,options|
      duel.opponent_action?(options[:user_id]) if options[:user_id]
    end
    expose :result do |duel,options|
      duel.result?(options[:user_id]) if options[:user_id]
    end

    expose :active do |duel, options|
      duel.rounds.last.active
    end
    expose :updated_at
  end
end
