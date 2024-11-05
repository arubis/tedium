# Tedium

Tedium is a Ruby gem that helps you gradually eliminate technical debt by removing one linting exclusion at a time from your StandardRB or RuboCop todo files.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tedium', github: 'arubis/tedium'
```

And then execute:

    $ bundle install

## Usage

Basic usage:

    $ bundle exec tedium

Options:
    -u, --unsafe-autocorrect   Allow unsafe autocorrections
    -t, --run-tests           Run test suite after linting
    -h, --help               Show this help message

The tool will:
1. Find either `.standard_todo.yml` or `.rubocop_todo.yml` in your project root
2. Select one active rule at random and remove it
3. Run the appropriate linter against the affected file
4. Optionally run your test suite

### Using with Binstubs

You can create a binstub for tedium:

    $ bundle binstub tedium

This will create `bin/tedium` in your project. You can then run:

    $ bin/tedium

The binstub will ensure the correct gem version is used based on your Gemfile.lock.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arubis/tedium.
