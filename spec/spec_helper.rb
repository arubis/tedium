require "bundler/setup"
require "tedium"
require "tempfile"
require "yaml"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
