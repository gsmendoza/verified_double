require 'spec_helper'

describe VerifiedDouble::SimpleDouble::MethodDouble do
  class Dummy
  end

  let(:class_name) {  'Dummy' }
  let(:some_instance_double) { double(class_name) }
  let(:simple_instance_double){ VerifiedDouble::SimpleDouble.new(some_instance_double) }
  let(:method_doubles){ simple_instance_double.method_doubles }

  describe "#method_signatures" do
    before do
      some_instance_double.stub(:save).with(force: true).and_return(false)
    end

    it "are the method signatures of the method double's message expectations" do
      expect(method_doubles[0].method_signatures.map(&:recommended_verified_signature).map(&:to_s))
        .to eq(["Dummy#save(Hash)=>VerifiedDouble::Boolean"])
    end
  end

  describe "#message_expectations" do
    before do
      some_instance_double.stub(:save).and_return(false)
      some_instance_double.should_receive(:save).with(force: true).and_return(true)
    end

    after do
      some_instance_double.save(force: true)
    end

    it "are the method expectations and stubs of the method double" do
      expect(method_doubles[0].message_expectations).to have(2).message_expectations
      method_doubles[0].message_expectations.each do |message_expectation|
        expect(message_expectation).to be_a(VerifiedDouble::SimpleDouble::MessageExpectation)
        expect(message_expectation.method_double).to eq(method_doubles[0])
        expect(message_expectation.internal).to be_a(RSpec::Mocks::MessageExpectation)
      end
    end
  end
end
