require 'spec_helper'

describe VerifiedDouble::RecordedMethodSignature do
  let(:relative_stack_frame_string){ "spec/verified_double/method_signatures_report_spec.rb:31:in `block (4 levels) in <top (required)>'" }

  let(:stack_frame_string){ "/verified_double/#{relative_stack_frame_string}" }

  subject { VerifiedDouble::StackFrame.new(stack_frame_string) }

  describe "#to_s" do
    it "strips the parent dir of spec from the string" do
      expect(subject.to_s).to eq("./#{relative_stack_frame_string}")
    end
  end
end
