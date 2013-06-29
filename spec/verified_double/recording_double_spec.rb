require 'unit_helper'
require "verified_double/recording_double"

describe VerifiedDouble::RecordingDouble do
  class Dummy
  end

  let(:class_name) {  'Dummy' }
  let(:some_instance_double) { double(class_name) }
  let(:some_class_double) { stub_const(class_name, Class.new) }

  let(:recording_instance_double) { VerifiedDouble::RecordingDouble.new(some_instance_double, class_name) }
  let(:recording_class_double) { VerifiedDouble::RecordingDouble.new(some_class_double, class_name) }

  describe "#initialize" do
    it "requires a double" do
      expect(recording_instance_double.double).to eq(some_instance_double)
    end

    context "with method_stubs hash" do
      let(:stubbed_method){ :some_method }
      let(:assumed_output){ :some_output }

      let(:recording_instance_double) {
        VerifiedDouble::RecordingDouble.new(
          some_instance_double,
          class_name,
          some_method: assumed_output) }

      it "stubs the methods of the instance" do
        expect(recording_instance_double.send(stubbed_method)).to eq(assumed_output)
      end
    end
  end

  it "delegates all unknown calls to its internal double" do
    some_instance_double.should_receive(:do_something)
    recording_instance_double.do_something
  end

  describe "#to_s" do
    context "where the internal double is a class" do
      it { expect(recording_class_double.to_s).to eq("VerifiedDouble.of_class('#{class_name}')") }
    end

    context "where the internal double is an instance" do
      let(:some_instance_double) { double(class_name) }

      it { expect(recording_instance_double.to_s).to eq("VerifiedDouble.of_instance('#{class_name}')") }
    end
  end

  describe "#inspect" do
    it "is human-readable representation of the recording double, NOT the internal double" do
      expect(recording_instance_double.inspect).to match("VerifiedDouble")
    end
  end

  describe "#class_name" do
    context "where the internal double is a double" do
      it "is the name of the class represented by the double" do
        expect(recording_instance_double.class_name).to eq(class_name)
      end
    end

    context "where the internal double is a stub const" do
      it "is the name of the class represented by the class double" do
        expect(recording_class_double.class_name).to eq(class_name)
      end
    end
  end

  describe "#class_double?" do
    it "should be true if the internal double is a class double" do
      expect(recording_instance_double).to_not be_class_double
    end

    it "should be false if the internal double is not an class double" do
      expect(recording_class_double).to be_class_double
    end
  end

  describe "#method_operator" do
    context "when the recording_instance_double wraps an instance double" do
      it "is #" do
        expect(recording_instance_double.method_operator).to eq("#")
      end
    end

    context "when the recording_instance_double wraps a class double" do
      it "is '.'" do
        expect(recording_class_double.method_operator).to eq(".")
      end
    end
  end

  describe "#should_receive(method)" do
    it "appends a new method signature with the method to the recording double's method signatures" do
      expect(recording_instance_double.method_signatures).to be_empty

      recording_instance_double.should_receive(:fake_to_s)
      recording_instance_double.should_receive(:fake_inspect)

      expect(recording_instance_double.method_signatures.map(&:method)).to eq(['fake_to_s', 'fake_inspect'])

      recording_instance_double.fake_to_s
      recording_instance_double.fake_inspect
    end
  end

  describe "#stub(method)" do
    it "appends a new method signature with the method to the recording double's method signatures" do
      expect(recording_instance_double.method_signatures).to be_empty

      recording_instance_double.stub(:fake_to_s)
      recording_instance_double.stub(:fake_inspect)

      expect(recording_instance_double.method_signatures.map(&:method)).to eq(['fake_to_s', 'fake_inspect'])
    end
  end

  describe "#with(*args)" do
    it "sets the args of the last method signature" do
      recording_instance_double.should_receive(:fake_to_s).with(:arg_1, :arg_2)

      expect(recording_instance_double.method_signatures[0].args).to be_all{|arg| arg.is_a?(VerifiedDouble::MethodSignature::Value) }
      expect(recording_instance_double.method_signatures[0].args.map(&:content)).to eq([:arg_1, :arg_2])

      recording_instance_double.fake_to_s(:arg_1, :arg_2)
    end
  end

  describe "#and_return(return_value)" do
    it "sets the return value of the last method signature" do
      recording_instance_double.should_receive(:fake_to_s).with(:arg_1, :arg_2).and_return(:return_value)

      return_values = recording_instance_double.method_signatures[0].return_values
      expect(return_values).to have(1).return_value
      expect(return_values.first).to be_a(VerifiedDouble::MethodSignature::Value)
      expect(return_values.first.content).to eq(:return_value)

      recording_instance_double.fake_to_s(:arg_1, :arg_2)
    end
  end

  describe "#once" do
    it "is relayed to the internal double and returns the recording double" do
      expect(recording_instance_double.should_receive(:fake_to_s).once).to be_a(described_class)
      recording_instance_double.fake_to_s
    end
  end

  describe "#twice" do
    it "is relayed to the internal double and returns the recording double" do
      expect(recording_instance_double.should_receive(:fake_to_s).twice).to be_a(described_class)
      recording_instance_double.fake_to_s
      recording_instance_double.fake_to_s
    end
  end

  describe "#at_least" do
    it "is relayed to the internal double and returns the recording double" do
      expect(recording_instance_double.should_receive(:fake_to_s).at_least(:once)).to be_a(described_class)
      recording_instance_double.fake_to_s
    end
  end

  describe "#at_most" do
    it "is relayed to the internal double and returns the recording double" do
      expect(recording_instance_double.should_receive(:fake_to_s).at_most(:once)).to be_a(described_class)
      recording_instance_double.fake_to_s
    end
  end

  describe "#any_number_of_times" do
    it "is relayed to the internal double and returns the recording double" do
      expect(recording_instance_double.should_receive(:fake_to_s).any_number_of_times).to be_a(described_class)
    end
  end

  describe "#and_raise" do
    let(:some_error){ Exception.new }

    it "is relayed to the internal double and returns the recording double" do
      expect(recording_instance_double.should_receive(:fake_to_s).and_raise(some_error)).to be_a(described_class)
      expect { recording_instance_double.fake_to_s }.to raise_error(some_error)
    end
  end

  describe "#and_raise" do
    it "is relayed to the internal double and returns the recording double" do
      expect(recording_instance_double.should_receive(:fake_to_s).and_throw(:some_error)).to be_a(described_class)
      expect { recording_instance_double.fake_to_s }.to throw_symbol(:some_error)
    end
  end

  describe "#class" do
    context "where the internal double is an instance" do
      it "is the constant matching the class name" do
        expect(recording_instance_double.class).to eq(Dummy)
      end
    end

    context "where the internal double is a class" do
      it { expect(recording_class_double.class).to eq(Class) }
    end
  end

  describe "#doubled_class" do
    context "where the internal double is an instance" do
      it "is the constant matching the class name" do
        expect(recording_instance_double.doubled_class).to eq(Dummy)
      end
    end

    context "where the internal double is a class" do
      it "is the constant matching the class name" do
        expect(recording_class_double.doubled_class).to eq(Dummy)
      end
    end
  end
end
