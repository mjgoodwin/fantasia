require_relative "support/simplecov.rb"

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/autorun"
require "trailblazer/rails/test/integration"

Dir[Rails.root.join("test/support/**/*.rb")].each {|f| require f}

Rails.backtrace_cleaner.remove_silencers!
