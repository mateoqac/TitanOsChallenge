class Country < ApplicationRecord
  has_many :availabilities, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :active, -> { where(active: true) }

  def self.available_codes
    active.pluck(:code)
  end
end
