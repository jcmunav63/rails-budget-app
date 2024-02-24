require 'capybara/rspec'

# JULIO'S CONFIG

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome, screen_size: [1920, 1080]
  end
end
