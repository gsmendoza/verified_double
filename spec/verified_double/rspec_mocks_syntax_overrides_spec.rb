require 'spec_helper'

describe VerifiedDouble::RSpecMocksSyntaxOverrides do
  include VerifiedDouble::RSpecMocksSyntaxOverrides 

  let(:a_double) { double('Object') }
  let(:some_method){ 'fake_to_s' }
  
  describe "#expect(*args)" do
    it "sets the registry's current_double to the first arg" do
      expect(VerifiedDouble.registry.last).to_not equal(a_double)
      expect(a_double)
      VerifiedDouble.registry.current_double.should equal(a_double)
    end
  end

  describe "#receive(*args)" do
    it "adds the first arg as a method signature for the current double" do
      expect(a_double).to receive(some_method).and_return(:result)

      method_signature = VerifiedDouble.registry.last
      expect(method_signature).to be_a(VerifiedDouble::MethodSignature)
      expect(method_signature.method).to equal(some_method)
      expect(method_signature.return_values.map(&:content)).to eq([:result])

      a_double.fake_to_s
    end
  end
end