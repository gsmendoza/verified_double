require 'spec_helper'

describe VerifiedDouble::RecordedMethodSignature do
  class Dummy
  end

  let(:stack_frame_string){ "./lib/verified_double/method_signature.rb:7:in `block in initialize'" }

  let(:attributes){
    { class_name:  'Dummy',
      method_operator: '#',
      stack_frame: VerifiedDouble::StackFrame.new(stack_frame_string) } }

  subject {
    described_class.new(attributes).tap {|method_signature|
      method_signature.method = 'do_something' } }

  describe "#to_s" do
    it "includes the stack frame" do
      expect(subject.to_s).to include(stack_frame_string)
    end
  end
end
