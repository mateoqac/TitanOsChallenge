class StreamingApp < ApplicationRecord
  has_many :availabilities, dependent: :destroy
  has_many :contents, through: :availabilities
  has_many :user_favorites, as: :favoritable, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def as_json_for_search(country_code = nil)
    {
      id: id,
      name: name,
      content_count: content_count_for_country(country_code)
    }
  end

  private

  def content_count_for_country(country_code)
    return availabilities.count unless country_code

    availabilities.joins(:country)
                  .where(countries: { code: country_code })
                  .distinct
                  .count
  end
end
