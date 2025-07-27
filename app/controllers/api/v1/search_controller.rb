class Api::V1::SearchController < ApplicationController
  def index
    country_code = params[:country]
    query = params[:q]

    unless valid_country_code?(country_code)
      return render json: {
        error: 'Invalid country code',
        available_countries: SearchService.available_countries
      }, status: :bad_request
    end

    unless query.present?
      return render json: { error: 'Query parameter is required' }, status: :bad_request
    end

    results = SearchService.global_search(query, country_code)
    render json: results
  end

  private

  def valid_country_code?(code)
    return false if code.blank?
    Country.exists?(code: code, active: true)
  end
end
