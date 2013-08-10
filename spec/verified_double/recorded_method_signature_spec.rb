require 'spec_helper'

describe VerifiedDouble::RecordedMethodSignature do
  class Dummy
  end

  let(:attributes){
    { class_name:  'Dummy',
      method_operator: '#' } }

  subject {
    described_class.new(attributes).tap {|method_signature|
      method_signature.method = 'do_something' } }

  describe "#to_s" do
    it "includes the stack frame" do
      expect(subject.to_s).to include(subject.stack_frame.to_s)
    end
  end

  describe "#initialize" do
    it "set the stack frame of the signature's caller" do
      expect(subject.stack_frame.to_s)
        .to include("./spec/verified_double/recorded_method_signature_spec.rb")
    end
  end
  
  it_behaves_like "it can initialize its stack frame within a shared example"
end
