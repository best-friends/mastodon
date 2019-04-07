# frozen_string_literal: true

if ENV['BUGSNAG_KEY']
  Bugsnag.configure do |config|
    config.api_key = ENV['BUGSNAG_KEY']
    config.send_environment = false
  end

  Bugsnag.load_integration(:sidekiq)
end
