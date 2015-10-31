class Round < ActiveRecord::Base
  belongs_to :duel
  has_many :actions, dependent: :destroy
  has_many :actors, through: :actions

  scope :finished, -> { where(:active => false) }

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
    elsif actions[0].type == "neutral" and actions[1].type == "defensive"
      result["type"] = "reloaded"
      result["defensive"] = actions[1].actor
      result["neutral"] = actions[0].actor
    elsif actions[1].type == "neutral" and actions[0].type == "defensive"
      result["type"] = "reloaded"
      result["defensive"] = actions[0].actor
      result["neutral"] = actions[1].actor
    elsif actions[0].type == actions[1].type
      type = actions[0].type
      result["action"] = type
      result["type"] = type == "offensive" ? "draw" :
                       type == "defensive" ? "both_blocked" :
                       type == "neutral" ? "both_reloaded" : "error"
    else
      result["type"] = "error"
    end

    result
  end

  def get_user_action user_id
    user_action = nil
    self.actions.each do |action|
      user_action = action if action.actor.user_id == user_id
    end
    user_action
  end

end
