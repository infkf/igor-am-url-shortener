require 'rails_helper'

RSpec.describe "Urls", type: :request do
  let(:valid_attributes) { { original_url: "https://rubyonrails.org" } }
  let(:invalid_attributes) { { original_url: "invalid" } }

  let(:auth_headers) do
    { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'password') }
  end

  describe "GET /urls" do
    it "requires authentication" do
      get urls_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a successful response when authenticated" do
      get urls_path, headers: auth_headers
      expect(response).to be_successful
    end
  end

  describe "GET /urls/new" do
    it "requires authentication" do
      get new_url_path
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns a successful response when authenticated" do
      get new_url_path, headers: auth_headers
      expect(response).to be_successful
    end
  end

  describe "POST /urls" do
    it "requires authentication" do
      post urls_path, params: { url: valid_attributes }
      expect(response).to have_http_status(:unauthorized)
    end

    context "with valid parameters and authentication" do
      it "creates a new Url" do
        expect {
          post urls_path, params: { url: valid_attributes }, headers: auth_headers
        }.to change(Url, :count).by(1)
      end

      it "redirects to the index" do
        post urls_path, params: { url: valid_attributes }, headers: auth_headers
        expect(response).to redirect_to(urls_path)
      end
    end

    context "with invalid parameters and authentication" do
      it "does not create a new Url" do
        expect {
          post urls_path, params: { url: invalid_attributes }, headers: auth_headers
        }.to change(Url, :count).by(0)
      end

      it "renders unprocessable_entity" do
        post urls_path, params: { url: invalid_attributes }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /urls/:id" do
    it "requires authentication" do
      url = Url.create!(original_url: "https://example.com")
      delete url_path(url)
      expect(response).to have_http_status(:unauthorized)
    end

    context "when authenticated" do
      it "deletes the URL" do
        url = Url.create!(original_url: "https://example.com")
        expect {
          delete url_path(url), headers: auth_headers
        }.to change(Url, :count).by(-1)
      end

      it "redirects to the index" do
        url = Url.create!(original_url: "https://example.com")
        delete url_path(url), headers: auth_headers
        expect(response).to redirect_to(urls_path)
      end
    end
  end
end
