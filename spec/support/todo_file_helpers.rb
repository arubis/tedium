module TodoFileHelpers
  def create_standard_todo_file(content)
    file = Tempfile.new(['.standard_todo', '.yml'])
    file.write(content.to_yaml)
    file.close
    file
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
