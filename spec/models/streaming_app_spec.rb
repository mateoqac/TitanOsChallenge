require 'rails_helper'

RSpec.describe StreamingApp, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:availabilities).dependent(:destroy) }
  it { should have_many(:contents).through(:availabilities) }
  it { should have_many(:user_favorites) }

  describe '#as_json_for_search' do
    let(:app) { create(:streaming_app, :netflix) }
    let(:country) { create(:country, :spain) }
    let(:content) { create(:content, :movie) }
    before { create(:availability, content: content, streaming_app: app, country: country) }
    it 'returns correct json' do
      json = app.as_json_for_search('es')
      expect(json[:name]).to eq('Netflix')
      expect(json[:content_count]).to eq(1)
    end
  end
end
