class Duel < ActiveRecord::Base
  has_many :actors
  has_many :users, through: :actors
  has_many :rounds
  has_many :actions, through: :rounds

  after_create :create_first_round

  def create_first_round
    first_round = Round.create(rid: 0, active: true)
    self.rounds << first_round
  end

  def end_of_round round
    return if self.winner

    Round.create(rid: self.rounds.length, duel_id: self.id, active: true)
  end

  def winner
    self.actors.each_with_index do |actor, index|
      return self.actors[(index - 1).abs] if actor.hit_points == 0
    end
    return false
  end

  def status
    "Du bist dran"
  end

  def bet_default
    self.bet == "" ? "Zufallsduel" : self.bet
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :bet_default, as: :bet
    expose :status
    expose :updated_at
  end
end
