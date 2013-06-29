require 'spec_helper'

describe VerifiedDouble::MethodSignature::RecordingDoubleClassValue do
  class Dummy
  end

  let(:class_name) {  'Dummy' }
  let(:some_class_double) { stub_const(class_name, Class.new) }
  let(:recording_class_double) { VerifiedDouble::RecordingDouble.new(some_class_double, class_name) }

  subject { described_class.new(recording_class_double) }

  describe "#belongs_to(other)" do
    context "where the doubled class of the recording double belongs to the other value" do
      it { expect(subject.belongs_to?(VerifiedDouble::MethodSignature::ClassValue.new(Dummy))).to be_true }
    end

    context "where the doubled class of the recording double does not belong to the other value" do
      it { expect(subject.belongs_to?(VerifiedDouble::MethodSignature::ClassValue.new(Object))).to be_false }
    end
  end

end
