class Character < ActiveRecord::Base
  has_many :users

  def order
    self.id - 1
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :order
    expose :name
    expose :name_de
    expose :description
  end
end
