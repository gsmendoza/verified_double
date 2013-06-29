require 'unit_helper'
require "verified_double/recording_double"

describe VerifiedDouble::RecordingDouble do
  let(:class_name) {  'Object' }
  let(:internal_double) { double(class_name) }

  subject { VerifiedDouble::RecordingDouble.new(internal_double, class_name) }

  describe "#initialize" do
    it "requires a double" do
      expect(subject.double).to eq(internal_double)
    end

    context "with method_stubs hash" do
      let(:stubbed_method){ :some_method }
      let(:assumed_output){ :some_output }

      subject { VerifiedDouble::RecordingDouble.new(internal_double, class_name, some_method: assumed_output) }

      it "stubs the methods of the instance" do
        expect(subject.send(stubbed_method)).to eq(assumed_output)
      end
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
      let(:internal_double) { stub_const(class_name, Class.new) }

      it { expect(subject.to_s).to eq("VerifiedDouble.of_class('#{class_name}')") }
    end

    context "where the internal double is an instance" do
      let(:class_name) { 'Dummy' }
      let(:internal_double) { double(class_name) }

      it { expect(subject.to_s).to eq("VerifiedDouble.of_instance('#{class_name}')") }
    end
  end

  describe "#inspect" do
    it "is human-readable representation of the recording double, NOT the internal double" do
      expect(subject.inspect).to match("VerifiedDouble")
    end
  end

  describe "#class_name" do
    context "where the internal double is a double" do
      it "is the name of the class represented by the double" do
        internal_double = double('Object')
        subject = described_class.new(internal_double, 'Object')
        expect(subject.class_name).to eq('Object')
      end
    end

    context "where the internal double is a stub const" do
      it "is the name of the class represented by the class double" do
        internal_double = stub_const('Object', Class.new)
        subject = described_class.new(internal_double, 'Object')
        expect(subject.class_name).to eq('Object')
      end
    end
  end

  describe "#class_double?" do
    it "should be true if the internal double is a class double" do
      internal_double = double('Object')
      subject = described_class.new(internal_double, 'Object')
      expect(subject).to_not be_class_double
    end

    it "should be false if the internal double is not an class double" do
      internal_double = stub_const('Object', Class.new)
      subject = described_class.new(internal_double, 'Object')
      expect(subject).to be_class_double
    end
  end

  describe "#method_operator" do
    context "when the subject wraps an instance double" do
      let(:internal_double) { double(class_name) }

      subject { VerifiedDouble::RecordingDouble.new(internal_double, class_name) }

      it "is #" do
        expect(subject.method_operator).to eq("#")
      end
    end

    context "when the subject wraps a class double" do
      let(:internal_double) { stub_const(class_name, Class.new) }

      subject { VerifiedDouble::RecordingDouble.new(internal_double, class_name) }

      it "is '.'" do
        expect(subject.method_operator).to eq(".")
      end
    end
  end

  describe "#should_receive(method)" do
    it "appends a new method signature with the method to the recording double's method signatures" do
      expect(subject.method_signatures).to be_empty

      subject.should_receive(:fake_to_s)
      subject.should_receive(:fake_inspect)

      expect(subject.method_signatures.map(&:method)).to eq(['fake_to_s', 'fake_inspect'])

      subject.fake_to_s
      subject.fake_inspect
    end
  end

  describe "#stub(method)" do
    it "appends a new method signature with the method to the recording double's method signatures" do
      expect(subject.method_signatures).to be_empty

      subject.stub(:fake_to_s)
      subject.stub(:fake_inspect)

      expect(subject.method_signatures.map(&:method)).to eq(['fake_to_s', 'fake_inspect'])
    end
  end

  describe "#with(*args)" do
    it "sets the args of the last method signature" do
      subject.should_receive(:fake_to_s).with(:arg_1, :arg_2)

      expect(subject.method_signatures[0].args).to be_all{|arg| arg.is_a?(VerifiedDouble::MethodSignatureValue) }
      expect(subject.method_signatures[0].args.map(&:content)).to eq([:arg_1, :arg_2])

      subject.fake_to_s(:arg_1, :arg_2)
    end
  end

  describe "#and_return(return_value)" do
    it "sets the return value of the last method signature" do
      subject.should_receive(:fake_to_s).with(:arg_1, :arg_2).and_return(:return_value)

      return_values = subject.method_signatures[0].return_values
      expect(return_values).to have(1).return_value
      expect(return_values.first).to be_a(VerifiedDouble::MethodSignatureValue)
      expect(return_values.first.content).to eq(:return_value)

      subject.fake_to_s(:arg_1, :arg_2)
    end
  end

  describe "#once" do
    it "is relayed to the internal double and returns the recording double" do
      expect(subject.should_receive(:fake_to_s).once).to be_a(described_class)
      subject.fake_to_s
    end
  end

  describe "#twice" do
    it "is relayed to the internal double and returns the recording double" do
      expect(subject.should_receive(:fake_to_s).twice).to be_a(described_class)
      subject.fake_to_s
      subject.fake_to_s
    end
  end

  describe "#at_least" do
    it "is relayed to the internal double and returns the recording double" do
      expect(subject.should_receive(:fake_to_s).at_least(:once)).to be_a(described_class)
      subject.fake_to_s
    end
  end

  describe "#at_most" do
    it "is relayed to the internal double and returns the recording double" do
      expect(subject.should_receive(:fake_to_s).at_most(:once)).to be_a(described_class)
      subject.fake_to_s
    end
  end

  describe "#any_number_of_times" do
    it "is relayed to the internal double and returns the recording double" do
      expect(subject.should_receive(:fake_to_s).any_number_of_times).to be_a(described_class)
    end
  end

  describe "#and_raise" do
    let(:some_error){ Exception.new }

    it "is relayed to the internal double and returns the recording double" do
      expect(subject.should_receive(:fake_to_s).and_raise(some_error)).to be_a(described_class)
      expect { subject.fake_to_s }.to raise_error(some_error)
    end
  end

  describe "#and_raise" do
    it "is relayed to the internal double and returns the recording double" do
      expect(subject.should_receive(:fake_to_s).and_throw(:some_error)).to be_a(described_class)
      expect { subject.fake_to_s }.to throw_symbol(:some_error)
    end
  end

  describe "#class" do
    it "is the constant matching the class name" do
      expect(subject.class).to eq(Object)
    end
  end
end
