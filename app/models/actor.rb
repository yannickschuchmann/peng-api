class Actor < ActiveRecord::Base
  belongs_to :duel
  belongs_to :user
  has_many :actions
  has_many :rounds, through: :actions

  self.inheritance_column = :_type_disabled

  after_initialize :defaults

  def defaults
    self.hit_points ||= 1
    self.shots ||= 1
  end
end
