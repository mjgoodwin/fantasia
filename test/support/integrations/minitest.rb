Minitest::Test.class_eval do
  def location
    loc = " [#{self.failure.location.split("fantasia/").last}]" unless passed? || error?
    test_class = self.class.to_s.gsub "::", " / "
    test_name = self.name.to_s.gsub /\Atest_\d{4,}_/, ""
    "#{test_class} / #{test_name}#{loc}"
  end
end

# require "minitest/reporters"
# Minitest::Reporters.use!(
#   Minitest::Reporters::SpecReporter.new,
#   ENV,
#   Minitest.backtrace_filter)
