require_relative "lib/tedium/version"

Gem::Specification.new do |spec|
  spec.name = "tedium"
  spec.version = Tedium::VERSION
  spec.authors = ["Dylan Fitzgerald"]
  spec.email = ["dylan@dylanfitzgerald.net"]
  spec.summary = "Gradually removes StandardRB and RuboCop todo entries"
  spec.description = "A tool to help gradually eliminate technical debt by removing one linting exclusion at a time"
  spec.homepage = "https://github.com/arubis/tedium"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "README.md", "exe/*"]
  spec.bindir = "exe"
  spec.executables = ["tedium"]
  spec.require_paths = ["lib"]
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_dependency "rubocop", ">= 1.0"
  spec.add_dependency "standard", ">= 1.0"
  spec.add_dependency "yaml", ">= 0.1"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
end
