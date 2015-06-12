class Action < ActiveRecord::Base
  belongs_to :round
  belongs_to :actor

  after_create :update_actor_shots
  after_create :call_round_evaluation

  self.inheritance_column = :_type_disabled

  def call_round_evaluation
    self.round.evaluate
  end

  def update_actor_shots
    actor = self.actor
    actor.shots = actor.shots + 1 if self.type == "neutral"
    actor.shots = actor.shots - 1 if self.type== "offensive" and actor.shots > 0

    actor.save
  end
end
