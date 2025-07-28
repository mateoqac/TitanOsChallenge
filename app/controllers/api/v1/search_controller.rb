class Api::V1::SearchController < ApplicationController
  include CountryValidatable

  def index
    country_code = params[:country]&.upcase
    query = params[:q]

    unless valid_country_code?(country_code)
      return render_invalid_country_error
    end

    unless query.present?
      return render json: { error: 'Query parameter is required' }, status: :bad_request
    end

    results = SearchService.global_search(query, country_code)

    # Renderizar con scope para el country_code
    render json: {
      contents: results[:contents],
      streaming_apps: results[:streaming_apps]
    }, scope: { country_code: country_code }
  end
end
