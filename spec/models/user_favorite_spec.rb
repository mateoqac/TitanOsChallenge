require 'rails_helper'

RSpec.describe UserFavorite, type: :model do
  subject { create(:user_favorite) }
  it { should belong_to(:favoritable) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:favoritable) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:favoritable_type, :favoritable_id) }

  describe '.favorite_apps_for_user' do
    let(:user_id) { 1 }
    let!(:app1) { create(:streaming_app, :netflix) }
    let!(:app2) { create(:streaming_app, :prime_video) }
    let!(:fav1) { create(:user_favorite, user_id: user_id, favoritable: app1, position: 2) }
    let!(:fav2) { create(:user_favorite, user_id: user_id, favoritable: app2, position: 1) }
    it 'returns apps ordered by position' do
      result = UserFavorite.favorite_apps_for_user(user_id)
      expect(result.first).to eq(fav2)
      expect(result.second).to eq(fav1)
    end
  end
end
