require 'rails_helper'

RSpec.describe ContentSerializer, type: :serializer do
  let(:content) { create(:content, :movie) }
  let(:serializer) { ContentSerializer.new(content) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  it 'includes the expected attributes' do
    json = JSON.parse(serialization.to_json)
    expect(json['id']).to eq(content.id)
    expect(json['title']).to eq(content.title)
    expect(json['type']).to eq(content.type)
    expect(json['year']).to eq(content.year)
    expect(json['duration_in_seconds']).to eq(content.duration_in_seconds)
  end

  it 'includes availabilities' do
    availability = create(:availability, content: content)
    json = JSON.parse(serialization.to_json)
    expect(json['availabilities']).to be_present
    expect(json['availabilities'].first['streaming_app_name']).to eq(availability.streaming_app.name)
  end
end
