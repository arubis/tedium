module TodoFileHelpers
  def create_standard_todo_file(content)
    File.write(".standard_todo.yml", content.to_yaml)
    ".standard_todo.yml"
  end

  def create_rubocop_todo_file(content)
    File.write(".rubocop_todo.yml", content.to_yaml)
    ".rubocop_todo.yml"
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
