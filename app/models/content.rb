class Content < ApplicationRecord
  self.inheritance_column = nil

  has_many :availabilities, dependent: :destroy
  has_many :streaming_apps, through: :availabilities
  has_many :countries, through: :availabilities
  has_many :schedules, dependent: :destroy
  has_many :viewing_times, dependent: :destroy
  has_many :user_favorites, as: :favoritable, dependent: :destroy

  # STI relationships
  belongs_to :tv_show, class_name: 'Content', optional: true
  belongs_to :season, class_name: 'Content', optional: true
  belongs_to :channel, class_name: 'Content', optional: true

  has_many :seasons, class_name: 'Content', foreign_key: 'tv_show_id'
  has_many :episodes, class_name: 'Content', foreign_key: 'season_id'
  has_many :channel_programs, class_name: 'Content', foreign_key: 'channel_id'

  validates :title, presence: true
  validates :type, presence: true

  scope :by_type, ->(content_type) { where(type: content_type) }
  scope :by_country, ->(country_code) { joins(:availabilities).joins(:countries).where(countries: { code: country_code }) }
end
