require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit

  config.include AcceptanceMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite)          { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each)           { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each)           { DatabaseCleaner.start }
  config.after(:each)            { DatabaseCleaner.clean }
end