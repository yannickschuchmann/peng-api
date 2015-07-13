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
    User.all.order(:updated_at).map(&:id).index(self.id) + 1 # very fake rank
  end

  def friends_count
    0
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

  def open_duels
    data = Duel::Entity.represent(self.duels, user_id: self.id)
  #   TODO
  end

  def last_duels
    data = Duel::Entity.represent(self.duels, user_id: self.id)
    #   TODO
  end

  def slogan_default
    !self.slogan ? "Hey there! I am using Peng." : self.slogan
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
    expose :slogan_default, as: :slogan
    expose :character_id
    expose :character_name
    expose :character_order
    expose :open_duels
    expose :last_duels
  end
end
