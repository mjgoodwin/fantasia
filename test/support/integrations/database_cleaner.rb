DatabaseCleaner.strategy = :transaction
Minitest::Spec.class_eval do
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end
