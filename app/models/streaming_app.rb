class StreamingApp < ApplicationRecord
  has_many :availabilities, dependent: :destroy
  has_many :contents, through: :availabilities
  has_many :user_favorites, as: :favoritable, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
