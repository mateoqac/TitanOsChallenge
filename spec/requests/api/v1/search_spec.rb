require 'rails_helper'

RSpec.describe "Api::V1::Search", type: :request do
  let(:country) { create(:country, :spain) }
  let(:streaming_app) { create(:streaming_app, :netflix) }
  let(:movie) { create(:content, :movie, title: 'Star Wars', year: 1980) }
  let(:tv_show) { create(:content, :tv_show, title: 'Stranger Things', year: 2016) }

  before do
    create(:availability, content: movie, streaming_app: streaming_app, country: country)
    create(:availability, content: tv_show, streaming_app: streaming_app, country: country)
  end

  describe "GET /api/v1/search" do
    context "with valid parameters" do
      it "searches by title" do
        get "/api/v1/search", params: { country: 'es', q: 'star' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['contents']).to include(
          hash_including('title' => 'Star Wars', 'type' => 'Movie')
        )
      end

      it "searches by year" do
        get "/api/v1/search", params: { country: 'es', q: '1980' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['contents']).to include(
          hash_including('year' => 1980)
        )
      end

      it "searches by streaming app name" do
        get "/api/v1/search", params: { country: 'es', q: 'netflix' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['streaming_apps']).to include(
          hash_including('name' => 'Netflix')
        )
      end

      it "returns both contents and apps when query matches both" do
        get "/api/v1/search", params: { country: 'es', q: 'star' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('contents', 'streaming_apps')
        expect(json_response['contents']).not_to be_empty
      end

      it "returns empty results when no matches found" do
        get "/api/v1/search", params: { country: 'es', q: 'nonexistent' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['contents']).to be_empty
        expect(json_response['streaming_apps']).to be_empty
      end
    end

    context "with invalid parameters" do
      it "returns error for invalid country" do
        get "/api/v1/search", params: { country: 'invalid', q: 'star' }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
        expect(json_response).to include('available_countries')
      end

      it "returns error for missing country" do
        get "/api/v1/search", params: { q: 'star' }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end

      it "returns error for missing query" do
        get "/api/v1/search", params: { country: 'es' }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end

      it "returns error for empty query" do
        get "/api/v1/search", params: { country: 'es', q: '' }

        expect(response).to have_http_status(:bad_request)
        json_response = JSON.parse(response.body)
        expect(json_response).to include('error')
      end
    end

    context "case insensitive search" do
      it "finds content regardless of case" do
        get "/api/v1/search", params: { country: 'es', q: 'STAR' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['contents']).to include(
          hash_including('title' => 'Star Wars')
        )
      end

      it "finds apps regardless of case" do
        get "/api/v1/search", params: { country: 'es', q: 'NETFLIX' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['streaming_apps']).to include(
          hash_including('name' => 'Netflix')
        )
      end
    end
  end
end
