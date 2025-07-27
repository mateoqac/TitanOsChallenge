require 'rails_helper'

RSpec.describe "Api::V1::Contents", type: :request do
  let(:country) { create(:country, :spain) }
  let(:streaming_app) { create(:streaming_app, :netflix) }
  let(:movie) { create(:content, :movie) }
  let(:tv_show) { create(:content, :tv_show) }
  let(:channel_program) { create(:content, :channel_program) }

  before do
    create(:availability, content: movie, streaming_app: streaming_app, country: country)
    create(:availability, content: tv_show, streaming_app: streaming_app, country: country)
    create(:availability, content: channel_program, streaming_app: streaming_app, country: country)
  end

  describe "GET /api/v1/contents" do
    context "with valid country code" do
      it "returns all contents for the country" do
        get "/api/v1/contents", params: { country: 'es' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(3)
        expect(json_response.map { |c| c['type'] }).to include('Movie', 'TvShow', 'ChannelProgram')
      end

      it "filters by content type" do
        get "/api/v1/contents", params: { country: 'es', type: 'Movie' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response.length).to eq(1)
        expect(json_response.first['type']).to eq('Movie')
      end

      it "returns empty array for non-existent content type" do
        get "/api/v1/contents", params: { country: 'es', type: 'NonExistent' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end

    context "with invalid country code" do
      it "returns error for invalid country" do
        get "/api/v1/contents", params: { country: 'invalid' }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
        expect(json_response).to include('available_countries')
      end

      it "returns error for missing country" do
        get "/api/v1/contents"

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end
    end
  end

  describe "GET /api/v1/contents/:id" do
    context "for regular content types" do
      it "returns content without viewing time" do
        get "/api/v1/contents/#{movie.id}"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(movie.id)
        expect(json_response['title']).to eq(movie.title)
        expect(json_response).not_to include('viewing_time')
      end

      it "returns content without viewing time even with user_id" do
        get "/api/v1/contents/#{movie.id}", params: { user_id: 123 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).not_to include('viewing_time')
      end
    end

    context "for channel program" do
      it "returns content without viewing time when no user_id provided" do
        get "/api/v1/contents/#{channel_program.id}"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(channel_program.id)
        expect(json_response).not_to include('viewing_time')
      end

      it "returns content with viewing time when user_id provided" do
        user_id = 123
        create(:viewing_time, content: channel_program, user_id: user_id, time_watched: 3600)

        get "/api/v1/contents/#{channel_program.id}", params: { user_id: user_id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(channel_program.id)
        expect(json_response['viewing_time']).to eq(3600)
      end

      it "returns zero viewing time when user has no viewing records" do
        get "/api/v1/contents/#{channel_program.id}", params: { user_id: 999 }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['viewing_time']).to eq(0)
      end
    end

    context "with non-existent content" do
      it "returns 404" do
        get "/api/v1/contents/999999"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
