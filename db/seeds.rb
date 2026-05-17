puts "Cleaning database..."
Url.destroy_all

puts "Creating sample URLs..."

urls = [
  "https://github.com/rails/rails",
  "https://rubyonrails.org",
  "https://tailwindcss.com",
  "https://news.ycombinator.com",
  "https://google.com"
]

urls.each do |original_url|
  url = Url.create!(original_url: original_url)
  # Simulate some random clicks
  url.update!(clicks_count: rand(0..150))
end

puts "Done! Created #{Url.count} sample URLs."
