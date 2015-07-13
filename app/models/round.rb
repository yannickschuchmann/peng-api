class Round < ActiveRecord::Base
  belongs_to :duel
  has_many :actions
  has_many :actors, through: :actions

  def evaluate
    return if self.actions.length != 2

    actions = self.actions

    result = self.get_result

    if result["type"] == "hit"
      result["victim"].hit_points = result["victim"].hit_points - 1
      result["victim"].save
    end

    self.active = false
    self.save

    self.duel.end_of_round self
  end

  def my_turn? user_id
    my_turn = true
    self.actions.each do |action|
      my_turn = false if action.actor.user_id == user_id
    end
    my_turn
  end

  def get_result
    return false if self.actions.length != 2

    actions = self.actions

    result = Hash.new()

    if actions[0].type == "offensive" and actions[1].type == "defensive"
      result["type"] = "blocked"
      result["offensive"] = actions[0].actor
      result["defensive"] = actions[1].actor
    elsif actions[1].type == "offensive" and actions[0].type == "defensive"
      result["type"] = "blocked"
      result["offensive"] = actions[1].actor
      result["defensive"] = actions[0].actor
    elsif actions[0].type == "offensive" and actions[1].type == "neutral"
      result["type"] = "hit"
      result["offensive"] = actions[0].actor
      result["victim"] = actions[1].actor
    elsif actions[1].type == "offensive" and actions[0].type == "neutral"
      result["type"] = "hit"
      result["offensive"] = actions[1].actor
      result["victim"] = actions[0].actor
    elsif actions[0].type == actions[1].type
      result["type"] = "same"
      result["action"] = actions[0].type
    end

    result
  end
end
