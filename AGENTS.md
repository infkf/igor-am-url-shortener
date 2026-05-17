# AGENTS.md

## Commands

```bash
bin/dev                    # Start dev server + Tailwind watch (via Foreman)
bin/rails server           # Rails server only (port 3000)
bin/rails console          # Rails console
bin/rails tailwindcss:watch # Watch & compile Tailwind CSS

bundle exec rspec                    # Run all tests
bundle exec rspec spec/models/url_spec.rb:4  # Single test by line

bin/rubocop                 # Lint Ruby (rubocop-rails-omakase style)
bin/rubocop -A              # Lint + auto-correct

bin/ci                      # Local CI: setup + rubocop + bundler-audit + importmap audit + brakeman
bin/brakeman                # Rails security scan
bin/bundler-audit           # Gem CVE scan
bin/importmap audit         # JS dependency vulnerability scan
```

**Important:** `bin/ci` and GitHub Actions do NOT run tests (`bundle exec rspec`). Tests must be run manually.

## Architecture

- **Rails 8.1** (Ruby 3.4.9), **SQLite3** in all environments (separate DBs for primary, cache, queue, cable).
- **No Node.js** — JavaScript via importmap-rails (Turbo, Stimulus). CSS via Tailwind CSS v4 (tailwindcss-rails gem).
- **No system tests**, no JavaScript/CSS build tooling. Generators configured with `config.generators.system_tests = nil`.

## Routes (order matters)

```ruby
root "urls#index"
resources :urls, only: [:index, :new, :create, :destroy]
get "/:short_code", to: "redirects#show"  # MUST be last — wildcard route
```

## Authentication

HTTP Basic Auth on all `/urls` actions. Controlled by ENV:
- `ADMIN_USERNAME` (default: `admin`)
- `ADMIN_PASSWORD` (default: `password`)

In tests, authenticate requests with:
```ruby
let(:auth_headers) do
  { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'password') }
end
```

The `/:short_code` redirect endpoint is **public** (no auth).

## URL model quirks

`Url` model (`app/models/url.rb:1`) does three things on `before_validation :create`:
1. Strips leading/trailing whitespace from `original_url`
2. Prepends `https://` if the URL is a bare domain (no protocol)
3. Generates a 6-char `short_code` via `SecureRandom.alphanumeric(6)` with uniqueness loop

Short code generation only runs if `short_code` is blank — a provided custom code is preserved.

## Boilerplate files (ignore these)

- `app/views/urls/create.html.erb` — scaffold placeholder, controller redirects instead
- `app/views/redirects/show.html.erb` — scaffold placeholder, controller redirects instead
- `app/javascript/controllers/hello_controller.js` — default Stimulus boilerplate
- `app/helpers/urls_helper.rb`, `app/helpers/redirects_helper.rb` — empty modules





