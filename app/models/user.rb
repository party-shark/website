class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :characters, dependent: :destroy
  belongs_to :rank

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def main_character
    self.characters.select { |c| c.main? }[0]
  end
end
