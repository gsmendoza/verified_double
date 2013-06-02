require 'unit_helper'
require "verified_double/recording_double"

describe VerifiedDouble::RecordingDouble do
  let(:class_name) {  'Object' }
  let(:internal_double) { double(class_name) }

  subject { VerifiedDouble::RecordingDouble.new(internal_double) }

  describe "#initialize" do
    it "requires a double" do
      expect(subject.double).to eq(internal_double)
    end
  end

  it "delegates all unknown calls to its internal double" do
    internal_double.should_receive(:do_something)
    subject.do_something
  end

  describe "#to_s" do
    class Dummy
    end

    context "where the internal double is a class" do
      let(:class_name) { 'Dummy' }
      let(:internal_double) { fire_class_double(class_name).as_replaced_constant }

      it { expect(subject.to_s).to eq("VerifiedDouble.of_class('#{class_name}')") }
    end

    context "where the internal double is an instance" do
      let(:class_name) { 'Dummy' }
      let(:internal_double) { fire_double(class_name) }

      it { expect(subject.to_s).to eq("VerifiedDouble.of_instance('#{class_name}')") }
    end
  end

  describe "#inspect" do
    it "is human-readable representation of the recording double, NOT the internal double" do
      expect(subject.inspect).to match("VerifiedDouble")
    end
  end

  describe "#class_name" do
    context "where the internal double is an RSpec::Fire::FireObjectDouble" do
      it "is the name of the class represented by the FireObjectDouble" do
        internal_double = fire_double('Object')
        subject = described_class.new(internal_double)
        expect(subject.class_name).to eq('Object')
      end
    end

    context "where the internal double is an rspec fire class double" do
      it "is the name of the class represented by the rspec fire class double" do
        internal_double = fire_class_double('Object').as_replaced_constant
        subject = described_class.new(internal_double)
        expect(subject.class_name).to eq('Object')
      end
    end
  end

  describe "#class_double?" do
    it "should be true if the internal double is an rspec fire class double" do
      internal_double = fire_double('Object')
      subject = described_class.new(internal_double)
      expect(subject).to_not be_class_double
    end

    it "should be false if the internal double is not an rspec fire class double" do
      internal_double = fire_class_double('Object').as_replaced_constant
      subject = described_class.new(internal_double)
      expect(subject).to be_class_double
    end
  end

  describe "#method_operator" do
    context "when the subject wraps an instance double" do
      let(:internal_double) { fire_double('Object') }

      subject { VerifiedDouble::RecordingDouble.new(internal_double) }

      it "is #" do
        expect(subject.method_operator).to eq("#")
      end
    end

    context "when the subject wraps a class double" do
      let(:internal_double) { fire_class_double('Object') }

      subject { VerifiedDouble::RecordingDouble.new(internal_double) }

      it "is '.'" do
        expect(subject.method_operator).to eq(".")
      end
    end
  end

  describe "#should_receive(method)" do
    it "appends a new method signature with the method to the recording double's method signatures" do
      expect(subject.method_signatures).to be_empty

      subject.should_receive(:to_s)
      subject.should_receive(:inspect)

      expect(subject.method_signatures.map(&:method)).to eq([:to_s, :inspect])

      subject.to_s
      subject.inspect
    end
  end

  describe "#with(*args)" do
    it "sets the args of the last method signature" do
      subject.should_receive(:to_s).with(:arg_1, :arg_2)

      expect(subject.method_signatures[0].args).to eq([:arg_1, :arg_2])

      subject.to_s(:arg_1, :arg_2)
    end
  end

  describe "#and_return(return_value)" do
    it "sets the return value of the last method signature" do
      subject.should_receive(:to_s).with(:arg_1, :arg_2).and_return(:return_value)

      expect(subject.method_signatures[0].return_value).to eq(:return_value)

      subject.to_s(:arg_1, :arg_2)
    end
  end
end
