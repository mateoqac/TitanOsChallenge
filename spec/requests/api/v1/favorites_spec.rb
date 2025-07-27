require 'rails_helper'

RSpec.describe "Api::V1::Favorites", type: :request do
  let(:user_id) { 123 }
  let(:streaming_app) { create(:streaming_app, :netflix) }
  let(:channel_program) { create(:content, :channel_program) }

  describe "GET /api/v1/favorites/channel_programs" do
    context "with valid user_id" do
      it "returns user's favorite channel programs" do
        create(:user_favorite, :for_content, user_id: user_id, favoritable: channel_program)

        get "/api/v1/favorites/channel_programs", params: { user_id: user_id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.first['id']).to eq(channel_program.id)
      end

      it "returns empty array when user has no favorites" do
        get "/api/v1/favorites/channel_programs", params: { user_id: user_id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end

    context "with invalid parameters" do
      it "returns error for missing user_id" do
        get "/api/v1/favorites/channel_programs"

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end

      it "returns error for empty user_id" do
        get "/api/v1/favorites/channel_programs", params: { user_id: '' }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end
    end
  end

  describe "GET /api/v1/favorites/apps" do
    context "with valid user_id" do
      it "returns user's favorite apps ordered by position" do
        app1 = create(:streaming_app, :netflix)
        app2 = create(:streaming_app, :prime_video)

        create(:user_favorite, user_id: user_id, favoritable: app1, position: 2)
        create(:user_favorite, user_id: user_id, favoritable: app2, position: 1)

        get "/api/v1/favorites/apps", params: { user_id: user_id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
        expect(json_response.length).to eq(2)
        expect(json_response.first['name']).to eq(app2.name) # Should be first due to position 1
      end

      it "returns empty array when user has no favorite apps" do
        get "/api/v1/favorites/apps", params: { user_id: user_id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end

    context "with invalid parameters" do
      it "returns error for missing user_id" do
        get "/api/v1/favorites/apps"

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end
    end
  end

  describe "POST /api/v1/favorites/apps" do
    context "with valid parameters" do
      it "creates a new app favorite" do
        post "/api/v1/favorites/apps", params: {
          user_id: user_id,
          app_id: streaming_app.id,
          position: 1
        }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['user_id']).to eq(user_id)
        expect(json_response['favoritable_id']).to eq(streaming_app.id)
        expect(json_response['position']).to eq(1)
      end

      it "updates existing app favorite position" do
        existing_favorite = create(:user_favorite, user_id: user_id, favoritable: streaming_app, position: 1)

        post "/api/v1/favorites/apps", params: {
          user_id: user_id,
          app_id: streaming_app.id,
          position: 3
        }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['position']).to eq(3)
      end
    end

    context "with invalid parameters" do
      it "returns error for missing user_id" do
        post "/api/v1/favorites/apps", params: { app_id: streaming_app.id, position: 1 }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end

      it "returns error for missing app_id" do
        post "/api/v1/favorites/apps", params: { user_id: user_id, position: 1 }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end

      it "returns error for missing position" do
        post "/api/v1/favorites/apps", params: { user_id: user_id, app_id: streaming_app.id }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end

      it "returns error for non-existent app" do
        post "/api/v1/favorites/apps", params: {
          user_id: user_id,
          app_id: 999999,
          position: 1
        }

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end
    end
  end
end
