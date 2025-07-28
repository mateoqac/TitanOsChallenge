class AvailabilitySerializer < ActiveModel::Serializer
  attributes :streaming_app_name, :market, :stream_info

  def streaming_app_name
    object.streaming_app.name
  end

  def market
    object.country.code
  end
end
