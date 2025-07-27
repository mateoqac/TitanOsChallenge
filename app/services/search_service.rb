class SearchService
  def self.global_search(query, country_code)
    return {} if query.blank?

    {
      contents: search_contents(query, country_code),
      streaming_apps: search_streaming_apps(query, country_code)
    }
  end

  def self.available_countries
    Country.active.pluck(:code)
  end

  private

  def self.search_contents(query, country_code)
    country = Country.find_by(code: country_code)
    return [] unless country

    # Buscar por título
    title_results = Content.joins(:availabilities)
                          .where(availabilities: { country: country })
                          .where("contents.title ILIKE ?", "%#{query}%")
                          .distinct

    # Buscar por año (si query es numérico)
    year_results = []
    if query.match?(/^\d{4}$/)
      year_results = Content.joins(:availabilities)
                           .where(availabilities: { country: country })
                           .where(contents: { year: query.to_i })
                           .distinct
    end

    # Combinar y eliminar duplicados
    all_results = (title_results + year_results).uniq
    all_results.map(&:as_json_for_api)
  end

  def self.search_streaming_apps(query, country_code)
    country = Country.find_by(code: country_code)
    return [] unless country

    # Buscar apps por nombre que tengan contenidos en el país
    apps = StreamingApp.joins(availabilities: :country)
                       .where(countries: { code: country_code })
                       .where("streaming_apps.name ILIKE ?", "%#{query}%")
                       .distinct

    apps.map { |app| app.as_json_for_search(country_code) }
  end
end
