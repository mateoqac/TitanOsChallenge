class Api::V1::ContentsController < ApplicationController
  def index
    country_code = params[:country]

    unless valid_country_code?(country_code)
      return render json: {
        error: 'Invalid country code',
        available_countries: ContentFilterService.available_countries
      }, status: :bad_request
    end

    contents = ContentFilterService.get_available_content(
      country_code,
      params[:type]
    )

    render json: contents.map(&:as_json_for_api)
  end

  def show
    content = Content.find(params[:id])
    user_id = params[:user_id]

    json_response = case content.type
    when 'ChannelProgram'
      viewing_time = user_id ? ViewingTimeService.get_time_watched(user_id, content.id) : nil
      content.as_json_for_channel_program(user_id, viewing_time)
    else
      content.as_json_for_api
    end

    render json: json_response
  end

  private

  def valid_country_code?(code)
    return false if code.blank?
    Country.exists?(code: code, active: true)
  end
end
