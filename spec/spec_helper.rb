require "bundler/setup"
require "tedium"
require "tedium/cli"
require "tedium/runner"
require "tempfile"
require "yaml"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
