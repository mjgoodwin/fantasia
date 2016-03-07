unless ENV['SUBLIME'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter "/config/"
    add_filter "/test/"

    add_group "Concepts",    "app/concepts"
    add_group "Controllers", "app/controllers"
    add_group "Lib",         "app/lib"
    add_group "Models",      "app/models"
  end
end
