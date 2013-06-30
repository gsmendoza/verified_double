require 'spec_helper'
require 'verified_double/method_signature/value'

describe VerifiedDouble::MethodSignature::Value do
  class Dummy
  end

  let(:class_name){ 'Dummy' }

  let(:value){ :some_value }

  describe ".from(content)" do
    subject { described_class.from(content) }

    context "where content is true" do
      let(:content) { true }
      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::BooleanValue) }
    end

    context "where content is false" do
      let(:content) { false }
      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::BooleanValue) }
    end

    context "where content is a class" do
      let(:content) { String }
      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::ClassValue) }
    end

    context "where content is a module" do
      let(:content) { VerifiedDouble }
      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::ClassValue) }
    end

    context "where content is an rspec mock" do
      let(:content) { double(:stuff) }
      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::RspecDoubleValue) }
    end

    context "where content is an class recording double" do
      let(:class_double){ stub_const(class_name, Class.new, transfer_nested_constants: true) }
      let(:content) { VerifiedDouble::RecordingDouble.new(class_double, class_name) }

      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::RecordingDoubleClassValue) }
    end

    context "where content is an instance recording double" do
      let(:some_instance_double){ double('Dummy') }
      let(:content) { VerifiedDouble::RecordingDouble.new(some_instance_double, class_name) }

      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::InstanceDoubleValue) }
    end

    context "where content is an instance" do
      let(:content) { :some_symbol }

      it { expect(subject).to be_a(VerifiedDouble::MethodSignature::InstanceValue) }
    end
  end

  describe "#content_class" do
    subject { method_signature_value.content_class }

    context "where the value is recording double" do
      let(:recording_double){ VerifiedDouble.of_instance('Object') }
      let(:method_signature_value) { described_class.new(recording_double) }

      it "is the class represented by the class_name of the recording double" do
        expect(subject).to eq(Object)
      end
    end

    context "where the value is not true or false" do
      let(:method_signature_value) { described_class.new(1) }
      it "is the class of the value" do
        expect(subject).to eq(Fixnum)
      end
    end
  end

  describe "#recommended_value" do
    subject { described_class.new(value) }

    it "is a version of self that will be recommended to users to verify" do
      expect(subject.recommended_value.content).to eq(subject.content_class)
      expect(subject.recommended_value.content).to_not eq(subject)
    end
  end
end
