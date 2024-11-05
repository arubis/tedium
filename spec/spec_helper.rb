$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "bundler/setup"
require "tedium"
require "tempfile"
require "yaml"

Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed

  config.after(:each) do
    FileUtils.rm_f(".rubocop_todo.yml")
    FileUtils.rm_f(".standard_todo.yml")
  end
end
