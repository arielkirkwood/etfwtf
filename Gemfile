# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# Domain level dependencies
gem 'mechanize', '~> 2.10' # mechanize fetches remote HTTP resources and handle file types selectively
gem 'money-rails', '~> 1.15' # money-rails allows handling a pair of money/currency columns as one money object
gem 'rubyXL', '~> 3.4' # rubyXL parses .xlsx XML files
gem 'validates_timeliness', '~> 7.0.0.beta2' # validates_timeliness provides complete validation of dates, times and datetimes

# Application/infrastructure level dependencies

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use Sass to process CSS
gem 'sassc-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Restorm is an ORM (Object Relational Mapper) that maps REST resources to Ruby objects.
gem 'restorm', '~> 1.0'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:windows, :jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem 'brakeman', '~> 6.1'
  gem 'bundler-audit', '~> 0.9.1'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: [:mri, :windows]
  gem 'rubocop-rails', '~> 2.26'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'vcr', '~> 6.3'
  gem 'webmock', '~> 3.24'
end
