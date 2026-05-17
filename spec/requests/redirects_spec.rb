require 'rails_helper'

RSpec.describe "Redirects", type: :request do
  describe "GET /:short_code" do
    let!(:url) { Url.create!(original_url: "https://example.com") }

    it "redirects to the original URL" do
      get short_redirect_path(url.short_code)
      expect(response).to redirect_to("https://example.com")
    end

    it "increments the clicks count" do
      expect {
        get short_redirect_path(url.short_code)
      }.to change { url.reload.clicks_count }.by(1)
    end

    it "returns a 404 if the short code is not found" do
      get short_redirect_path("invalid")
      expect(response).to have_http_status(:not_found)
    end
  end
end
