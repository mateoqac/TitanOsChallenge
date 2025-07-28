module CountryValidatable
  extend ActiveSupport::Concern

  private

  def valid_country_code?(code)
    return false if code.blank?
    Country.exists?(code: code, active: true)
  end

  def available_countries
    Country.active.pluck(:code)
  end

  def render_invalid_country_error
    render json: {
      error: "Invalid country code",
      available_countries: available_countries
    }, status: :bad_request
  end
end
