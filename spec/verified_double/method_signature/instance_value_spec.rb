require 'unit_helper'

describe VerifiedDouble::MethodSignature::InstanceValue do
  describe "#belongs_to?(other)" do
    subject { this.belongs_to?(other) }

    context "where the other value is an instance and self's value matches it" do
      let(:this){ described_class.new(1) }
      let(:other){ described_class.new(1) }
      it { expect(subject).to be_true }
    end

    context "where the other value is an instance and self's value does not match it" do
      let(:this){ described_class.new(2) }
      let(:other){ described_class.new(1) }
      it { expect(subject).to be_false }
    end

    context "where self is an instance and the other's class is an ancestor of self's modified class" do
      let(:this){ described_class.new(1) }
      let(:other){ VerifiedDouble::MethodSignature::ClassValue.new(Object) }
      it { expect(subject).to be_true }
    end

    context "where self is an instance and the other's class is not an ancestor of self's modified class" do
      let(:this){ described_class.new(1) }
      let(:other){ VerifiedDouble::MethodSignature::ClassValue.new(Float) }
      it { expect(subject).to be_false }
    end
  end

  describe "#content_as_instance" do
    subject { described_class.new(:some_value) }

    it "returns the value" do
      expect(subject.content_as_instance).to eq(:some_value)
    end
  end
end
