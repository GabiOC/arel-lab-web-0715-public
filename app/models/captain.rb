class Captain < ActiveRecord::Base
  has_many :boats

  def self.catamaran_operators
    catamaran_id = Classification.where(name: 'Catamaran').pluck(:id)
    catamaran = BoatClassification.where(classification_id: catamaran_id).pluck(:boat_id)
    captain_id = Boat.where(id: catamaran).pluck(:captain_id)
    self.where(id: captain_id)
  end

  def self.sailors
    captain_id = Boat.sailboats.pluck(:captain_id)
    self.where(id: captain_id)
  end

  def self.talented_seamen
    # find captains of sailboats
    # find captains of motorboats
    # find overlap

    motorboat_id = Classification.where(name: 'Motorboat').pluck(:id)
    motorboat = BoatClassification.where(classification_id: motorboat_id).pluck(:boat_id)
    captain_id = Boat.where(id: motorboat).pluck(:captain_id)
    motorboat_captains = self.where(id: captain_id)

    sailboat_captains = self.sailors

    overlap = motorboat_captains & sailboat_captains
    # convoluted workaround below to turn array into ActiveRecord::Relation for 'pluck' method in spec
    self.where(id: overlap.map(&:id))
  end

  def self.non_sailors
    sailors = self.sailors
    where.not(id: sailors)
  end

end
