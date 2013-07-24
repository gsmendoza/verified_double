require 'spec_helper'

describe VerifiedDouble::RSpecMocksSyntaxOverrides do
  let(:a_double) { double('Object') }
  let(:some_method){ 'fake_to_s' }
  let(:some_result){ 'result' }

  describe "#expect(*args)" do
    it "sets the registry's current_double to the first arg", verifies_contract: 'Object#fake_to_s()=>String' do
      expect(VerifiedDouble.registry.last).to_not eq(a_double)
      expect(a_double)
      VerifiedDouble.registry.current_double.should eq(a_double)
    end
  end

  describe "#allow(*args)" do
    it "sets the registry's current_double to the first arg", verifies_contract: 'Object#fake_to_s()=>String' do
      expect(VerifiedDouble.registry.last).to_not eq(a_double)

      allow(a_double)

      VerifiedDouble.registry.current_double.should eq(a_double)
    end
  end

  describe "#receive(*args)" do
    it "adds the first arg as a method signature for the current double" do
      expect(a_double).to receive(some_method).and_return(some_result)

      method_signature = VerifiedDouble.registry.last
      expect(method_signature).to be_a(VerifiedDouble::MethodSignature)
      expect(method_signature.method).to eq(some_method)
      expect(method_signature.return_values.map(&:content)).to eq([some_result])

      a_double.fake_to_s
    end
  end
end