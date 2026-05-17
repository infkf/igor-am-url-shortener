require 'rails_helper'

RSpec.describe Url, type: :model do
  describe "validations" do
    it "is valid with a valid http url" do
      url = Url.new(original_url: "http://example.com")
      expect(url).to be_valid
    end

    it "is valid with a valid https url" do
      url = Url.new(original_url: "https://example.com")
      expect(url).to be_valid
    end

    it "is invalid without an original_url" do
      url = Url.new(original_url: nil)
      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include("can't be blank")
    end

    it "is invalid with an invalid url format" do
      url = Url.new(original_url: "not_a_url")
      expect(url).not_to be_valid
      expect(url.errors[:original_url]).to include("is invalid")
    end
  end

  describe "callbacks" do
    it "generates a short code before validation on create" do
      url = Url.new(original_url: "https://example.com")
      expect(url.short_code).to be_nil
      url.valid?
      expect(url.short_code).to be_present
      expect(url.short_code.length).to eq(6)
    end

    it "does not overwrite an existing short_code" do
      url = Url.new(original_url: "https://example.com", short_code: "custom")
      url.valid?
      expect(url.short_code).to eq("custom")
    end
  end
end
