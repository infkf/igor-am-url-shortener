class Url < ApplicationRecord
  before_validation :generate_short_code, on: :create

  validates :original_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
  validates :short_code, presence: true, uniqueness: true

  private

  def generate_short_code
    return if short_code.present?

    loop do
      self.short_code = SecureRandom.alphanumeric(6)
      break unless Url.exists?(short_code: short_code)
    end
  end
end
