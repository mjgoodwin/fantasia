require 'simplecov'
SimpleCov.start do
  add_filter "/config/"
  add_filter "/test/"

  add_group "Concepts", "app/concepts"
  add_group "Controllers", "app/controllers"
  add_group "Lib", "app/lib"
  add_group "Models", "app/models"
end

if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  ENV['CODECOV_TOKEN'] = '473c8c5b-10ee-4d83-86c6-bfd72a185a27'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/autorun"
require "trailblazer/rails/test/integration"

require "minitest/reporters"
# Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new]#, Minitest::Reporters::MeanTimeReporter.new]
Minitest::Reporters.use!(
  Minitest::Reporters::ProgressReporter.new,
  ENV,
  Minitest.backtrace_filter)

Rails.backtrace_cleaner.remove_silencers!

Minitest::Spec.class_eval do
  after :each do
    # DatabaseCleaner.clean
    Team.delete_all
    User.delete_all
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
