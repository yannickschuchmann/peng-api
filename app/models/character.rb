class Character < ActiveRecord::Base
  has_many :users

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :order
    expose :name
    expose :name_de
    expose :description
    expose :description_de
  end
end
