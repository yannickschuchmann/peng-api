class User < ActiveRecord::Base
  has_many :actors
  has_many :duels, through: :actors
  has_many :actions, through: :actors
  belongs_to :character

  after_create :new_user

  def new_user
    WebsocketRails.users.each do |connection|
      connection.send_message "user.new", {users: User.all}
    end
  end

  def rank
    14
  end

  def friends_count
    7
  end

  def duels_count
    self.duels.count
  end

  def character_name
    cn = self.character.try(:name)
    cn ? cn : "medic"
  end

  def character_order
    if self.character
      self.character.order
    else
      1
    end
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    expose :id
    expose :nick
    expose :duels_count
    expose :friends_count
    expose :rank
    expose :slogan
    expose :character_id
    expose :character_name
    expose :character_order
  end
end
