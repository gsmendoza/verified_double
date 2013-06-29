require 'unit_helper'
require 'verified_double/method_signature/value'

describe VerifiedDouble::MethodSignature::Value do
  let(:value){ :some_value }

  describe ".from(content" do
    it "requires a value from a method signature" do
      described_class.from(value)
    end
  end

  describe "#belongs_to?(other)" do
    subject { this.belongs_to?(other) }

    context "where self's value is an actual class and other's value matches it" do
      let(:this){ described_class.new(Fixnum) }
      let(:other){ described_class.new(Fixnum) }
      it { expect(subject).to be_true }
    end

    context "where self's value is an actual class and other's value does not match it" do
      let(:this){ described_class.new(Fixnum) }
      let(:other){ described_class.new(Object) }
      it { expect(subject).to be_false }
    end

    context "where the other value is an instance and self's value matches it" do
      let(:this){ described_class.new(1) }
      let(:other){ described_class.new(1) }
      it { expect(subject).to be_true }
    end

    context "where the other value is an instance and self's value does not it" do
      let(:this){ described_class.new(2) }
      let(:other){ described_class.new(1) }
      it { expect(subject).to be_false }
    end

    context "where self is an instance and the other's class is an ancestor of self's modified class" do
      let(:this){ described_class.new(1) }
      let(:other){ described_class.new(Object) }
      it { expect(subject).to be_true }
    end

    context "where self is an instance and the other's class is not an ancestor of self's modified class" do
      let(:this){ described_class.new(1) }
      let(:other){ described_class.new(Float) }
      it { expect(subject).to be_false }
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

    context "where the value is a double" do
      let(:d){ double('Object') }
      let(:method_signature_value) { described_class.new(d) }

      it "is the class represented by the class_name of the recording double" do
        expect(subject).to eq(Object)
      end
    end

    context "where the value is true" do
      let(:method_signature_value) { described_class.new(true) }
      it { expect(subject).to eq(VerifiedDouble::Boolean) }
    end

    context "where the value is false" do
      let(:method_signature_value) { described_class.new(false) }
      it { expect(subject).to eq(VerifiedDouble::Boolean) }
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

  describe "#content_as_instance" do
    context "where the value is an instance" do
      subject { described_class.new(:some_value) }

      it "returns the value" do
        expect(subject.content_as_instance).to eq(:some_value)
      end
    end

    context "where the value is a class which can be initialized" do
      subject { described_class.new(String) }

      it "returns the initialized instance of the value " do
        expect(subject.content_as_instance).to eq(String.new)
      end
    end

    context "where the value is a class which cannot be initialized" do
      subject { described_class.new(Integer) }

      it "returns an object" do
        expect(subject.content_as_instance).to be_an(Object)
      end
    end
  end
end
