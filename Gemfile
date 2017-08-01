source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'rails-ujs'
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'slim-rails'

gem 'devise'

gem 'carrierwave'

gem 'thinking-sphinx'
gem 'mysql2'


gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'bootstrap-generators', '~> 3.3.4'

gem 'remotipart'
gem 'cocoon'

gem 'skim'

gem 'active_model_serializers'

gem 'responders', '~> 2.0'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

gem 'cancancan'
gem 'doorkeeper'

gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil

gem 'whenever', :require => false

gem 'oj'
gem 'oj_mimic_json'

gem 'dotenv-rails', require: 'dotenv/rails-now'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.3.3'
end

group :development, :test do
  gem 'faker'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-email'
  gem 'database_cleaner'

  gem 'pry-rails'
  gem 'pry-nav'
  gem 'launchy'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'rails-controller-testing'
end

group :test do
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'json_spec'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'
  #gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'letter_opener'

  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
