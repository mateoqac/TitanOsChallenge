class SearchService < BaseService
  def self.global_search(query, country_code)
    return {} if query.blank?

    {
      contents: search_contents(query, country_code),
      streaming_apps: search_streaming_apps(query, country_code)
    }
  end

  private

  def self.search_contents(query, country_code)
    valid, country = validate_country_exists(country_code)
    return [] unless valid

    title_results = Content.joins(:availabilities)
                          .where(availabilities: { country: country })
                          .where("contents.title ILIKE ?", "%#{query}%")
                          .distinct

    year_results = []
    if query.match?(/^\d{4}$/)
      year_results = Content.joins(:availabilities)
                           .where(availabilities: { country: country })
                           .where(contents: { year: query.to_i })
                           .distinct
    end

    all_results = (title_results + year_results).uniq
    all_results
  end

  def self.search_streaming_apps(query, country_code)
    valid, country = validate_country_exists(country_code)
    return [] unless valid

    apps = StreamingApp.joins(availabilities: :country)
                       .where(countries: { code: country_code })
                       .where("streaming_apps.name ILIKE ?", "%#{query}%")
                       .distinct

    apps
  end
end
