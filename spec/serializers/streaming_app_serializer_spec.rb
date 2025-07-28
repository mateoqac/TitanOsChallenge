require 'rails_helper'

RSpec.describe StreamingAppSerializer, type: :serializer do
  let(:app) { create(:streaming_app, :netflix) }
  let(:serializer) { StreamingAppSerializer.new(app) }
  let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

  it 'includes the expected attributes' do
    json = JSON.parse(serialization.to_json)
    expect(json['id']).to eq(app.id)
    expect(json['name']).to eq(app.name)
  end

  it 'includes content_count without country_code in scope' do
    create(:availability, streaming_app: app)
    json = JSON.parse(serialization.to_json)
    expect(json['content_count']).to eq(1)
  end

  it 'includes content_count filtered by country_code in scope' do
    country_es = create(:country, :spain)
    country_gb = create(:country, :uk)
    content_es = create(:content, :movie)
    content_gb = create(:content, :movie)

    create(:availability, streaming_app: app, content: content_es, country: country_es)
    create(:availability, streaming_app: app, content: content_gb, country: country_gb)

    serializer_with_scope = StreamingAppSerializer.new(app, scope: { country_code: 'ES' })
    serialization_with_scope = ActiveModelSerializers::Adapter.create(serializer_with_scope)
    json = JSON.parse(serialization_with_scope.to_json)

    expect(json['content_count']).to eq(1)
  end
end
