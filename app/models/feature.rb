class Feature < ApplicationRecord
  validates :title, :place, :mag_type, :longitude, :latitude, presence: true
  validates :magnitude, inclusion: { in: -1.0..10.0}
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  validate :coordinates_present
  validate :check_for_duplicates, on: :create

  has_many :comments

  private

  def coordinates_present
    errors.add(:coordinate, "No puede ser vacio/nulo") unless longitude.present? && latitude.present?
  end

  def check_for_duplicates
    duplicate = Feature.find_by(external_id: external_id)
    errors.add(:base, "Ya existe un registro con este ID") if duplicate.present?
  end
end
