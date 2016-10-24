ENV['NEW_RELIC_ENV'] = 'test'

require 'bundler'
Bundler.require
require './lib/eureka_bot/tg'
require 'webmock/rspec'
# require 'vcr'
require 'factory_girl'

$:.unshift File.dirname(__FILE__) + '/..'
Dir['spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include WebRequestHelper
  config.include SettingsHelper
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
    # lint_time = Benchmark.realtime do
    #   factories_for_lint = FactoryGirl.factories.select{|f| f.send(:class_name) != Hash}
    #   FactoryGirl.lint(factories_for_lint)
    # end
    # puts "=== FactoryGirl.lint complete in #{lint_time} seconds ==="
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  # config.warnings = true

  config.profile_examples = 10
  config.order            = :random

  # tag to disable VCR and WebMock
  # it 'Real web request', :novcr { ... }
  config.around do |example|
    if example.metadata[:novcr]
      with_web_request do
        example.run
      end
    else
      example.run
    end
  end

  Kernel.srand config.seed
end

# VCR.configure do |c|
#   c.cassette_library_dir = 'spec/cassettes'
#   c.hook_into :webmock
#   c.configure_rspec_metadata!
# end
