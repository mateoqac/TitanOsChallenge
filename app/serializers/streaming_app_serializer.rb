class StreamingAppSerializer < ActiveModel::Serializer
  attributes :id, :name, :content_count

  def content_count
    return object.availabilities.count unless scope&.dig(:country_code)

    object.availabilities.joins(:country)
                .where(countries: { code: scope[:country_code] })
                .distinct
                .count
  end
end
