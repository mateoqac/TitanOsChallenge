class ContentFilterService
  def self.get_available_content(country_code, type = nil)
    country = Country.find_by(code: country_code)
    return Content.none unless country

    contents = Content.joins(:availabilities)
                      .where(availabilities: { country: country })

    contents = contents.where(type: type) if type.present?

    contents.distinct
  end

  def self.available_countries
    Country.active.pluck(:code)
  end
end
