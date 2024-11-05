require "spec_helper"

RSpec.describe Tedium::Runner do
  let(:runner) { described_class.new(options) }
  let(:options) { {} }

  describe "#run" do
    context "when no todo files exist" do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it "reports that no todo files were found" do
        expect { runner.run }.to output(/No todo files found/).to_stdout
      end
    end

    context "with a standard todo file" do
      let(:todo_file) { create_standard_todo_file(standard_todo_content) }

      before do
        allow(File).to receive(:exist?).with(".standard_todo.yml").and_return(true)
        allow(File).to receive(:exist?).with(".rubocop_todo.yml").and_return(false)
        allow(YAML).to receive(:load_file).and_return(standard_todo_content)
      end

      after { todo_file.unlink }

      it "runs standardrb on the selected file" do
        success_result = instance_double(Process::Status, success?: true)
        allow(Open3).to receive(:capture3).with(
          "bundle", "exec", "standardrb", "--fix", kind_of(String)
        ).and_return(["", "", success_result])

        runner.run
      end

      context "with unsafe autocorrect" do
        let(:options) { {unsafe_autocorrect: true} }

        it "uses the unsafe fix flag" do
          success_result = instance_double(Process::Status, success?: true)
          allow(Open3).to receive(:capture3).with(
            "bundle", "exec", "standardrb", "--fix-unsafely", kind_of(String)
          ).and_return(["", "", success_result])

          runner.run
        end
      end

      context "when removing the last rule" do
        let(:final_rule_content) do
          {
            "ignore" => [
              {
                "app/models/user.rb" => ["Style/StringLiterals"]
              }
            ]
          }
        end
        let(:todo_file) { create_standard_todo_file(final_rule_content) }

        before do
          allow(YAML).to receive(:load_file).and_return(final_rule_content)
          allow(Open3).to receive(:capture3).and_return(["", "", double(success?: true)])
        end

        it "deletes the todo file" do
          allow(File).to receive(:delete).with(".standard_todo.yml")
          runner.run
        end
      end
    end

    context "with a rubocop todo file" do
      before do
        allow(File).to receive(:exist?).with(".standard_todo.yml").and_return(false)
        allow(File).to receive(:exist?).with(".rubocop_todo.yml").and_return(true)
        allow(YAML).to receive(:load_file).and_return(standard_todo_content)
      end

      it "runs rubocop on the selected file" do
        success_result = instance_double(Process::Status, success?: true)
        allow(Open3).to receive(:capture3).with(
          "bundle", "exec", "rubocop", "-a", kind_of(String)
        ).and_return(["", "", success_result])

        runner.run
      end

      context "with unsafe autocorrect" do
        let(:options) { {unsafe_autocorrect: true} }

        it "uses the unsafe autocorrect flag" do
          success_result = instance_double(Process::Status, success?: true)
          allow(Open3).to receive(:capture3).with(
            "bundle", "exec", "rubocop", "-A", kind_of(String)
          ).and_return(["", "", success_result])

          runner.run
        end
      end
    end

    context "when running tests is enabled" do
      let(:options) { {run_tests: true} }

      before do
        allow(File).to receive(:exist?).with(".standard_todo.yml").and_return(true)
        allow(YAML).to receive(:load_file).and_return(standard_todo_content)
        allow(Open3).to receive(:capture3).and_return(["", "", double(success?: true)])
      end

      it "runs the test suite after linting" do
        allow(runner).to receive(:system).with("bundle exec rake test")
        runner.run
      end
    end
  end
end
