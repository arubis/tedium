require "spec_helper"

RSpec.describe "CLI", type: :integration do
  let(:cli) { Tedium::CLI.new }

  def run_cli(args = [])
    ARGV.replace(args)
    cli.start
  rescue SystemExit => e
    e.status
  end

  describe "option parsing" do
    it "accepts --unsafe-autocorrect" do
      runner_spy = class_spy(Tedium::Runner)
      stub_const("Tedium::Runner", runner_spy)
      run_cli(["--unsafe-autocorrect"])
      expect(runner_spy).to have_received(:run).with(hash_including(unsafe_autocorrect: true))
      run_cli(["--unsafe-autocorrect"])
    end

    it "accepts --run-tests" do
      runner_spy = class_spy(Tedium::Runner)
      stub_const("Tedium::Runner", runner_spy)
      run_cli(["--run-tests"])
      expect(runner_spy).to have_received(:run).with(hash_including(run_tests: true))
      run_cli(["--run-tests"])
    end

    it "shows help and exits cleanly with --help" do
      expect { run_cli(["--help"]) }.to output(/Usage: tedium/).to_stdout
    end
  end
end
