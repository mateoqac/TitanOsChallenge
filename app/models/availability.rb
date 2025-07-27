class Availability < ApplicationRecord
  belongs_to :content
  belongs_to :streaming_app
  belongs_to :country

  validates :country, presence: true
  validates :streaming_app, presence: true
  validates :content, presence: true

  scope :by_country, ->(country_code) { joins(:country).where(countries: { code: country_code }) }

  def as_json
    {
      streaming_app_name: streaming_app.name,
      market: country.code,
      stream_info: stream_info
    }
  end
end
