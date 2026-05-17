class Url < ApplicationRecord
  before_validation :normalize_original_url, :generate_short_code, on: :create

  validates :original_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :short_code, presence: true, uniqueness: true

  private

  def normalize_original_url
    return if original_url.blank?

    original_url.strip!
    return if original_url.match?(/\Ahttps?:\/\//)

    original_url.prepend("https://") if original_url.match?(/\A[\w.-]+\.[a-z]{2,}/i)
  end

  def generate_short_code
    return if short_code.present?

    loop do
      self.short_code = SecureRandom.alphanumeric(6)
      break unless Url.exists?(short_code: short_code)
    end
  end
end
