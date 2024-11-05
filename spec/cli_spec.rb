RSpec.describe Tedium::CLI do
  let(:cli) { described_class.new }

  describe "#parse_options" do
    it "defaults to safe options" do
      allow(ARGV).to receive(:[]).and_return(nil)
      options = cli.send(:parse_options)
      expect(options[:unsafe_autocorrect]).to be false
      expect(options[:run_tests]).to be false
    end

    it "enables unsafe autocorrections with -u flag" do
      ARGV.replace(["-u"])
      options = cli.send(:parse_options)
      expect(options[:unsafe_autocorrect]).to be true
    end

    it "enables test suite run with -t flag" do
      ARGV.replace(["-t"])
      options = cli.send(:parse_options)
      expect(options[:run_tests]).to be true
    end
  end
end
