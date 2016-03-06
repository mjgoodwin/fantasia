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

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  ENV['CODECOV_TOKEN'] = 'e80bb932-9378-4ff7-bc90-437729944729'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/autorun"
require "trailblazer/rails/test/integration"

# require "minitest/reporters"
# Minitest::Reporters.use!(
#   Minitest::Reporters::SpecReporter.new,
#   ENV,
#   Minitest.backtrace_filter)

Rails.backtrace_cleaner.remove_silencers!

DatabaseCleaner.strategy = :transaction
Minitest::Spec.class_eval do
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

Minitest::Test.class_eval do
  def location
    loc = " [#{self.failure.location.split("fantasia/").last}]" unless passed? || error?
    test_class = self.class.to_s.gsub "::", " / "
    test_name = self.name.to_s.gsub /\Atest_\d{4,}_/, ""
    "#{test_class} / #{test_name}#{loc}"
  end
end

Cell::TestCase.class_eval do
  include Capybara::DSL
  include Capybara::Assertions
end

Trailblazer::Test::Integration.class_eval do
  def sign_in!(email="mike@example.com", password="123456")
    sign_up!(email, password) #=> Session::SignUp

    visit "/sessions/sign_in_form"

    submit!(email, password)
  end

  def sign_up!(email="mike@example.com", password="123456")
    Session::SignUp.(user: {email: email, password: password, confirm_password: password})
  end

  def submit!(email, password)
    within("//form[@id='new_session']") do
      fill_in 'Email',    with: email
      fill_in 'Password', with: password
    end
    click_button "Enter"
  end
end

module LeagueSetupHelper
  def create_league!(name: "Mickey Mouse League", commissioner: nil, start_time: nil)
    commissioner ||= User::Create.(user: {email: "mike@example.com"}).model
    League::Create.(league:
      { name: "Mickey Mouse League",
        commissioner: commissioner,
        rounds: [{ start_time: start_time || Time.now.end_of_day }] }
    ).model
  end
end
