require 'spec_helper'

describe VerifiedDouble::SimpleDouble::MessageExpectation do
  class Dummy
  end

  let(:class_name) {  'Dummy' }
  let(:some_instance_double) { double(class_name) }
  let(:simple_instance_double){ VerifiedDouble::SimpleDouble.new(some_instance_double) }
  let(:method_double){ simple_instance_double.method_doubles[0] }
  let(:message_expectation){ method_double.message_expectations[0] }

  describe "#method_signature" do
    before do
      some_instance_double.should_receive(:save).with(force: true).and_return(false)
    end

    after do
      some_instance_double.save(force: true)
    end

    it "builds a new method signature from the expectation" do
      method_signature = message_expectation.method_signature
      expect(method_signature).to be_a(VerifiedDouble::MethodSignature)
      expect(method_signature.args.map(&:content)).to eq([{force: true}])
      expect(method_signature.class_name).to eq(class_name)
      expect(method_signature.method).to eq(:save)
      expect(method_signature.method_operator).to eq('#')
      expect(method_signature.return_values.map(&:content)).to eq([false])
    end
  end

  describe "#args" do
    context "when it expects a message with args" do
      before do
        some_instance_double.should_receive(:save).with(force: true).and_return(false)
      end

      after do
        some_instance_double.save(force: true)
      end

      it "are the args of the double's message expectationbuilds a new method signature from the expectation" do
        expect(message_expectation.args[0]).to be_a(VerifiedDouble::MethodSignature::Value)
        expect(message_expectation.args.map(&:content)).to eq([{force: true}])
      end
    end

    context "when it expects a message without args" do
      before do
        some_instance_double.should_receive(:save).and_return(false)
      end

      after do
        some_instance_double.save
      end

      it "are empty" do
        expect(message_expectation.args).to be_empty
      end
    end
  end

  describe "#return_values" do
    it "are the return_values of the double's message expectationbuilds a new method signature from the expectation" do
      some_instance_double.stub(:save).and_return(false)
      expect(message_expectation.return_values).to have(1).result
      expect(message_expectation.return_values.map(&:content)).to eq([false])
    end
  end
end
