require 'yaml'
require 'pathname'
require_relative 'tedium/cli'

module Tedium
  class Error < StandardError; end

  class Runner
    TODO_FILES = [
      '.standard_todo.yml',
      '.rubocop_todo.yml'
    ].freeze

    def self.run(options = {})
      new(options).run
    end

    def initialize(options = {})
      @options = options
    end

    def run
      todo_file = find_todo_file
      return puts 'No todo files found' unless todo_file

      yaml_content = YAML.load_file(todo_file)
      return puts "No ignore rules found in #{todo_file}" unless yaml_content&.dig('ignore')

      process_todo_file(todo_file, yaml_content)
    end

    private

    def find_todo_file
      TODO_FILES.find { |file| File.exist?(file) }
    end

    def process_todo_file(todo_file, yaml_content)
      is_standard = todo_file == '.standard_todo.yml'
      ignore_entries = yaml_content['ignore']

      file_entry = ignore_entries.sample
      return puts 'No files to process' unless file_entry

      file_path = file_entry.keys.first
      rules = file_entry[file_path]

      rule_to_remove = rules.sample
      return puts "No rules to remove for #{file_path}" unless rule_to_remove

      rules.delete(rule_to_remove)
      puts "Removed rule: #{rule_to_remove} from #{file_path}"

      ignore_entries.delete_if { |entry| entry.keys.first == file_path } if rules.empty?

      if ignore_entries.empty?
        File.delete(todo_file)
        puts "Removed empty todo file: #{todo_file}"
      else
        File.write(todo_file, yaml_content.to_yaml)
      end

      run_linter(file_path, is_standard)
      run_tests if @options[:run_tests]
    end

    def run_linter(file_path, is_standard)
      unsafe_flag = if @options[:unsafe_autocorrect]
                      (is_standard ? '--fix-unsafely' : '-A')
                    else
                      (is_standard ? '--fix' : '-a')
                    end

      command = if is_standard
                  "bundle exec standardrb #{unsafe_flag} #{file_path}" # Changed from standard to standardrb
                else
                  "bundle exec rubocop #{unsafe_flag} #{file_path}"
                end

      puts "\nRunning: #{command}"
      result = system(command)

      if result
        puts "\nLinting completed successfully!"
        if @options[:unsafe_autocorrect]
          puts 'WARNING: Unsafe autocorrections were allowed. Please review changes carefully.'
          puts 'Running your test suite is highly recommended.' unless @options[:run_tests]
        end
      else
        puts "\nLinting completed with some errors."
        puts 'Some issues may require manual intervention.'
      end
    end

    def run_tests
      puts "\nRunning test suite..."
      if system('bundle exec rake test')
        puts 'Test suite passed!'
      else
        puts 'Test suite failed! Please review the changes and fix any issues.'
      end
    end
  end
end
