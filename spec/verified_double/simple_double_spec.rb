require 'spec_helper'

describe VerifiedDouble::SimpleDouble do
  class Dummy
  end

  let(:class_name) {  'Dummy' }
  let(:some_instance_double) { double(class_name) }
  let(:some_class_double) { stub_const(class_name, Class.new) }

  let(:simple_instance_double) { described_class.new(some_instance_double) }
  let(:simple_class_double) { described_class.new(some_class_double) }

  describe "#initialize" do
    it "requires a double" do
      expect(simple_instance_double.internal).to eq(some_instance_double)
    end
  end

  describe "#class_name" do
    context "where the internal double is a double" do
      it "is the name of the class represented by the double" do
        expect(simple_instance_double.class_name).to eq(class_name)
      end
    end

    context "where the internal double is a stub const" do
      it "is the name of the class represented by the class double" do
        expect(simple_class_double.class_name).to eq(class_name)
      end
    end
  end

  describe "#class_double?" do
    it "should be true if the internal double is a class double" do
      expect(simple_instance_double).to_not be_class_double
    end

    it "should be false if the internal double is not an class double" do
      expect(simple_class_double).to be_class_double
    end
  end

  describe "#method_operator" do
    context "when the simple_instance_double wraps an instance double" do
      it "is #" do
        expect(simple_instance_double.method_operator).to eq("#")
      end
    end

    context "when the simple_instance_double wraps a class double" do
      it "is '.'" do
        expect(simple_class_double.method_operator).to eq(".")
      end
    end
  end

  describe "#build_record_method_signature(method)" do
    let(:method){ :fake_to_s }
    subject { simple_instance_double.build_recorded_method_signature(method) }

    it "returns a method signature for the method of the double" do
      expect(subject).to be_a(VerifiedDouble::RecordedMethodSignature)
      expect(subject.class_name).to eq(class_name)
      expect(subject.method_operator).to eq('#')
      expect(subject.method).to eq(method.to_s)
    end
  end
end
