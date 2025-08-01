class Api::V1::SearchController < ApplicationController
  include CountryValidatable

  def index
    country_code = params.require(:country).upcase
    query = params.require(:q)

    unless valid_country_code?(country_code)
      return render_invalid_country_error
    end

    results = SearchService.global_search(query, country_code)

    render json: {
      contents: results[:contents],
      streaming_apps: results[:streaming_apps]
    }, scope: { country_code: country_code }
  end
end
