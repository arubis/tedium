require "optparse"

module Tedium
  class CLI
    def self.start
      new.start
    end

    def start
      options = parse_options
      Runner.run(options)
    end

    private

    def parse_options
      options = {
        unsafe_autocorrect: false,
        run_tests: false
      }

      OptionParser.new do |opts|
        opts.banner = "Usage: tedium [options]"

        opts.on("-u", "--unsafe-autocorrect", "Allow unsafe autocorrections") do
          options[:unsafe_autocorrect] = true
        end

        opts.on("-t", "--run-tests", "Run test suite after linting") do
          options[:run_tests] = true
        end

        opts.on("-h", "--help", "Show this help message") do
          puts opts
          exit
        end
      end.parse!

      if options[:run_tests] && !options[:unsafe_autocorrect]
        warn "Warning: --run-tests is most useful with --unsafe-autocorrect"
      end

      options
    end
  end
end
