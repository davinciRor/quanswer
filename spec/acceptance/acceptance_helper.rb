require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  Capybara.server = :puma

  config.include AcceptanceMacros, type: :feature
  config.include OmniauthMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite)              { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each)               { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true)     { DatabaseCleaner.strategy = :truncation }
  config.before(:each, sphinx: true) { DatabaseCleaner.strategy = :deletion }
  config.before(:each)               { DatabaseCleaner.start }
  config.after(:each)                { DatabaseCleaner.clean }
end

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.allow_url("https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js")
  config.allow_url("oss.maxcdn.com")
  config.allow_url("https://oss.maxcdn.com/respond/1.4.2/respond.min.js")
  config.allow_url("oss.maxcdn.com")
end

OmniAuth.config.test_mode = true