source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'pg', '~> 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 4.1'

gem 'exception_hunter', '~> 0.4'

gem 'devise', '~> 4.7.2'
gem 'devise_token_auth', '~> 1.1.3'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'oj', '~> 3.10.13'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails', '~> 0.3.9'
  gem 'rubocop', '~> 0.90.0', require: false
  gem 'rspec-rails', '~> 4.0.1'
  gem 'factory_bot_rails', '~> 6.1.0'
  gem 'faker', '~> 1.9'

end

group :development do
  gem 'letter_opener', '~> 1.7.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails_best_practices', '~> 1.19.4'
  gem 'reek', '~> 5.5'
  gem 'bullet', '~> 6.1.0'

end

group :test do
  gem 'timecop', '~> 0.9.1'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'database_cleaner', '~> 1.7'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'active_model_serializers', '~> 0.10.8'
