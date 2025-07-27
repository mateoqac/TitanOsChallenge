require 'rails_helper'

RSpec.describe FavoriteService, type: :service do
  let(:user_id) { 1 }
  let(:app) { create(:streaming_app, :netflix) }
  let(:program) { create(:content, :channel_program) }

  it 'gets favorite apps for user' do
    create(:user_favorite, user_id: user_id, favoritable: app, position: 1)
    result = FavoriteService.get_favorite_apps(user_id)
    expect(result.first[:name]).to eq('Netflix')
  end

  it 'gets favorite channel programs for user' do
    create(:user_favorite, :for_content, user_id: user_id, favoritable: program)
    result = FavoriteService.get_favorite_channel_programs(user_id)
    expect(result.first[:id]).to eq(program.id)
  end

  it 'adds a new app favorite' do
    result = FavoriteService.add_app_favorite(user_id, app.id, 1)
    expect(result[:success]).to be true
    expect(result[:favorite].user_id).to eq(user_id)
    expect(result[:favorite].favoritable).to eq(app)
  end
end
