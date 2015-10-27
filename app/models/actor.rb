class Actor < ActiveRecord::Base
  belongs_to :duel
  belongs_to :user
  has_many :actions
  has_many :rounds, through: :actions

  self.inheritance_column = :_type_disabled

  after_initialize :defaults

  def defaults
    self.hit_points ||= 1
    self.shots ||= 0
  end

  def nick
    self.user.try(:nick)
  end

  def character_name
    self.user.try(:character_name)
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :user_id
    expose :duel_id
    expose :hit_points
    expose :shots
    expose :type
    expose :nick
    expose :character_name
  end
end
