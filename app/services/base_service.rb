class BaseService
  class << self
    def available_countries
      Country.active.pluck(:code)
    end

    def find_country_by_code(country_code)
      Country.find_by(code: country_code)
    end

    def validate_country_exists(country_code)
      country = find_country_by_code(country_code)
      return [false, nil] unless country
      [true, country]
    end
  end
end
