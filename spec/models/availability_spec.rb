require 'rails_helper'

RSpec.describe Availability, type: :model do
  it { should belong_to(:content) }
  it { should belong_to(:streaming_app) }
  it { should belong_to(:country) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:streaming_app) }
  it { should validate_presence_of(:content) }

  describe '#as_json' do
    let(:availability) { create(:availability) }
    it 'returns a hash with expected keys' do
      json = availability.as_json
      expect(json).to include(:streaming_app_name, :market, :stream_info)
    end
  end
end
