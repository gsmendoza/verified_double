RSpec.configure do |config|
  config.include VerifiedDouble::Matchers

  config.before do
    self.extend VerifiedDouble::RSpecMocksSyntaxOverrides
  end

  config.after do
    VerifiedDouble.doubles_in_current_test.clear
  end

  config.after :suite do
    VerifiedDouble.report_unverified_signatures(self)
  end
end
