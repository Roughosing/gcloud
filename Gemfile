source "https://rubygems.org"

# Core
gem "rails", "~> 8.0.2"
gem "mysql2"
gem "puma", ">= 5.0"
gem "bootsnap", require: false

# Frontend
gem "propshaft"
gem "turbo-rails"
gem "stimulus-rails"
gem "importmap-rails"
gem "heroicon"

# Authentication & Authorization
gem "devise"
gem "pundit"

# Forms
gem "simple_form"

# File handling
gem "image_processing", "~> 1.2"
gem "active_storage_validations"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "erb-formatter"
  gem "erb_lint"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "webmock"
  gem "rails-controller-testing"
end
