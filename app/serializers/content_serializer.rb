class ContentSerializer < ActiveModel::Serializer
  attributes :id, :title, :year, :duration_in_seconds, :type

  has_many :availabilities, serializer: AvailabilitySerializer

  def type
    object.type
  end
end
