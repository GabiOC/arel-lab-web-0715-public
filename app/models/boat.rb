class Boat < ActiveRecord::Base
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  def self.first_five
    limit(5)
  end

  def self.dinghy
    where('length < 20')
  end

  def self.ship
    where('length > 20')
  end

  def self.last_three_alphabetically
    order(name: :desc).limit(3)
  end

  def self.without_a_captain
    where(captain: nil)
  end

  def self.sailboats
    sailboat_id = Classification.where(name: 'Sailboat').pluck(:id)
    sailboat = BoatClassification.where(classification_id: sailboat_id).pluck(:boat_id)
    self.where(id: sailboat)
  end

  def self.with_three_classifications
    boats = BoatClassification.all.pluck(:boat_id)
    three_classes = boats.select{|boat| boats.count(boat) == 3}.uniq
    self.where(id: three_classes)
  end
end
