require 'unit_helper'
require 'verified_double/method_signature_value'

describe VerifiedDouble::MethodSignatureValue do
  let(:value){ :some_value }

  describe "#initialize" do
    it "requires a value from a method signature" do
      described_class.new(value)
    end
  end

  describe "#accepts?(other)" do
    subject { this.accepts?(other) }

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

  describe "#modified_class" do
    subject { method_signature_value.modified_class }

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
      expect(subject.recommended_value.value).to eq(subject.modified_class)
      expect(subject.recommended_value.value).to_not eq(subject)
    end
  end
end
