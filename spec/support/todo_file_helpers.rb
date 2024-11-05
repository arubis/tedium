module TodoFileHelpers
  def create_standard_todo_file(content)
    path = ".standard_todo.yml"
    File.write(path, content.to_yaml)
    Tempfile.new.tap do |temp|
      temp.write(content.to_yaml)
      temp.rewind
      def temp.path
        ".standard_todo.yml"
      end
    end
  end

  def create_rubocop_todo_file(content)
    path = ".rubocop_todo.yml" 
    File.write(path, content.to_yaml)
    Tempfile.new.tap do |temp|
      temp.write(content.to_yaml)
      temp.rewind
      def temp.path
        ".rubocop_todo.yml"
      end
    end
  end

  def standard_todo_content
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
end

RSpec.configure do |config|
  config.include TodoFileHelpers
end
