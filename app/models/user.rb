class User < ActiveRecord::Base
  has_many :actors
  has_many :duels, through: :actors
  has_many :actions, through: :actors
  belongs_to :character
  has_many :user_provider


  after_create :new_user

  def initialize(attributes={})
    attr_with_defaults = {
      :slogan => "Hey there! I am using Peng.",
      :character_id => Character.find_by_name("medic").id
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def self.ranking
    def ranking_sort
      duels_count != 0 ? duels_won_count / duels_count : -1
    end
    User.all.sort_by(&:ranking_sort).reverse
  end

  def new_user
    WebsocketRails.users.each do |connection|
      connection.send_message "user.new", {users: User.all}
    end
  end

  def rank
    User.ranking.map(&:id).index(self.id) + 1 # very fake rank
  end

  def friends_count
    0
  end

  def duels_count
    self.duels.count
  end

  def character_id
    self.character.try(:id)
  end

  def character_name
    self.character.try(:name)
  end

  def character_order
    self.character.try(:order)
  end

  def open_duels
    duels = self.duels.select do |duel|
      !duel.winner
    end
    data = Duel::Entity.represent(duels, user_id: self.id)
  end

  def last_duels
    duels = self.duels.select do |duel|
      duel.winner
    end
    data = Duel::Entity.represent(duels, user_id: self.id)
  end

  def slogan_default
    !self.slogan ? "Hey there! I am using Peng." : self.slogan
  end

  def entity
    Entity.new(self)
  end

  class Entity < Grape::Entity
    with_options(format_with: :empty_string) do
      expose :id
      expose :nick
      expose :email
      expose :first_name
      expose :last_name
      expose :picture
      expose :slogan
      expose :character_name
      expose :character_order
    end
    expose :character_id
    expose :duels_count
    expose :duels_won_count
    expose :friends_count
    expose :rank
    expose :open_duels
    expose :last_duels

    private
      def empty_string(value)
        value || ""
      end
  end
end
