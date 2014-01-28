# Character
# A character is defined by it's name and server. We will then pull
# down information about them from the Blizz API.
#
# Fields we want from Blizz:
# - Class
# - Level
# - Achievement Points
# - Average Equiped iLvL
# - Spec
# - Role
# - Thumbnail URL
# - Guild Name
#
class Character < ActiveRecord::Base
  # A user must own the character.
  belongs_to :user

  # Validate the two fields needed to look up a character.
  validates :name, presence: true, length: { maximum: 12 }
  validates :server, presence: true
  validates_uniqueness_of :name, scope: :server
  validates_with CharacterValidator

  # FIXME: This should be rethought.
  after_save :reconcile

  # Make sure we assign a new main, if there are no
  # other characters, fail.
  before_destroy :reassign

  # -> String
  # A character is displayed by it's name.
  #
  def to_s
    self.name.titleize
  end

  def armory_url
    "http://us.battle.net/wow/en/character/#{server}/#{name}/advanced"
  end

  # -> WoW::Character
  # Returns the result of the wow gems call to the blizz API.
  #
  def api
    fields = [:items, :talents, :guild]
    @api ||= WoW::Character.new(self.server, self.name, fields)
  end

  # Sync the data from blizz api with out data model.
  def sync!
    self.update_columns klass: api.get("class"),
      level: api["level"],
      achievement_points: api["achievementPoints"],
      average_item_level_equiped: api["items"]["averageItemLevelEquipped"],
      spec: api.get("active_spec")["spec"]["name"],
      role: api.get("active_spec")["spec"]["role"],
      thumbnail: api.get("thumbnail"),
      guild_name: api["guild"]["name"]
  end

  private

  # FIXME: This should be thought through more.
  def reconcile
    sync!

    if self.main?
      self.user.characters.where.not(id: self.id).update_all(main: false)
    else
      self.user.characters.first.update_column(:main, true)
    end
  end

  def reassign
    if self.main?
      characters = self.user.characters
      if characters.reject(&:marked_for_destruction?).count <= 1
        self.errors.add(:base, "Cannot destroy only character")
        return false
      else
        characters.where.not(id: self.id).first.update_attribute(:main, true)
      end
    end
  end

end
