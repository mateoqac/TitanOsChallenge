class ContentFilterService < BaseService
  def self.get_available_content(country_code, type = nil)
    valid, country = validate_country_exists(country_code)
    return Content.none unless valid

    contents = Content.joins(:availabilities)
                      .where(availabilities: { country: country })

    contents = contents.where(type: type) if type.present?

    contents.distinct
  end

  def self.available_countries
    Country.active.pluck(:code)
  end
end
