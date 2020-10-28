# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'

gem 'pg', '~> 1.2.3'

# Dotenv gem
gem 'dotenv-rails', groups: %i[development test]

# Use Puma as the app server
gem 'puma', '~> 4.1'

gem 'devise', '~> 4.7.2'
gem 'devise_token_auth', '~> 1.1.3'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'google-id-token', git: 'https://github.com/google/google-id-token.git'
gem 'oj', '~> 3.10.13'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1.1'

gem 'jbuilder'
gem 'listen', '~> 3.2'

# Push notifications
gem 'fcm'

# Scheaduling jobs
gem "whenever", require: false

gem 'aws-sdk-s3', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails', '~> 0.3.9'
  gem 'rubocop', '~> 0.90.0', require: false

  gem 'factory_bot_rails', '~> 6.1.0'
  gem 'faker', '~> 1.9'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'timecop', '~> 0.9.1'
end

group :development do
  gem 'letter_opener', '~> 1.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'bullet', '~> 6.1.0'
  gem 'rails_best_practices', '~> 1.19.4'
  gem 'reek', '~> 5.5'
end

group :test do
  gem 'database_cleaner', '~> 1.7'
  gem 'shoulda-matchers', '~> 3.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'active_storage_base64', '~> 1.1'
gem 'pagy', '~> 3.8'
gem 'pagy_cursor', '~> 0.2.0'

gem 'aws-sdk-rails', '~> 3.1'
