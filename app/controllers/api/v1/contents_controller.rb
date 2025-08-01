class Api::V1::ContentsController < ApplicationController
  include CountryValidatable

  def index
    country_code = params.require(:country).upcase

    unless valid_country_code?(country_code)
      return render_invalid_country_error
    end

    contents = ContentFilterService.get_available_content(
      country_code,
      params[:type]
    )

    render json: contents
  end

  def show
    content = Content.find(params[:id])
    user_id = params[:user_id]

    serializer = SerializerFactory.create_serializer(content, { user_id: user_id })

    render json: serializer.as_json
  end
end
