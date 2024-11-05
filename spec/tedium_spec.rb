RSpec.describe Tedium::Runner do
  let(:options) { {} }
  let(:runner) { described_class.new(options) }
  let(:standard_todo_content) do
    {
      "ignore" => [
        {
          "app/models/user.rb" => [
            "Style/StringLiterals",
            "Layout/SpaceInsideHashLiteralBraces"
          ]
        },
        {
          "app/controllers/posts_controller.rb" => [
            "Style/StringLiterals",
            "Metrics/MethodLength"
          ]
        }
      ]
    }
  end

  describe "#find_todo_file" do
    context "when .standard_todo.yml exists" do
      before do
        allow(File).to receive(:exist?).with(".standard_todo.yml").and_return(true)
        allow(File).to receive(:exist?).with(".rubocop_todo.yml").and_return(false)
      end

      it "returns .standard_todo.yml" do
        expect(runner.send(:find_todo_file)).to eq(".standard_todo.yml")
      end
    end

    context "when neither file exists" do
      before do
        allow(File).to receive(:exist?).with(".standard_todo.yml").and_return(false)
        allow(File).to receive(:exist?).with(".rubocop_todo.yml").and_return(false)
      end

      it "returns nil" do
        expect(runner.send(:find_todo_file)).to be_nil
      end
    end
  end

  describe "command line options" do
    describe "unsafe autocorrections" do
      let(:options) { {unsafe_autocorrect: true} }

      it "uses --fix-unsafely with standard" do
        expect(runner).to receive(:system).with("bundle exec standard --fix-unsafely some/file.rb")
        runner.send(:run_linter, "some/file.rb", true)
      end

      it "uses -A with rubocop" do
        expect(runner).to receive(:system).with("bundle exec rubocop -A some/file.rb")
        runner.send(:run_linter, "some/file.rb", false)
      end
    end

    describe "test suite execution" do
      let(:options) { {run_tests: true} }

      it "runs the test suite after linting" do
        temp_file = Tempfile.new([".standard_todo", ".yml"])
        File.write(temp_file.path, standard_todo_content.to_yaml)

        allow(runner).to receive(:run_linter)
        expect(runner).to receive(:run_tests)

        runner.send(:process_todo_file, temp_file.path, YAML.load_file(temp_file.path))

        temp_file.unlink
      end
    end
  end
end
