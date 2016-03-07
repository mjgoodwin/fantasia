if ENV['CI'] == 'true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
  ENV['CODECOV_TOKEN'] = 'e80bb932-9378-4ff7-bc90-437729944729'
end
