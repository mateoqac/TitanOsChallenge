require 'rails_helper'

RSpec.describe Country, type: :model do
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
  it { should validate_presence_of(:name) }
  it { should have_many(:availabilities).dependent(:destroy) }

  describe '.active' do
    it 'returns only active countries' do
      active = create(:country, active: true)
      inactive = create(:country, :inactive)
      expect(Country.active).to include(active)
      expect(Country.active).not_to include(inactive)
    end
  end
end
