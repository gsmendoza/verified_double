require 'unit_helper'

describe VerifiedDouble::MethodSignature::ClassValue do
  subject { described_class.new(String) }

  describe "#belongs_to?(other)" do
    context "where the value and other have the same content" do
      let(:other) { described_class.new(String) }
      it { expect(subject.belongs_to?(other)).to be_true }
    end

    context "where the value and other do not have the same content" do
      let(:other) { described_class.new(Object) }
      it { expect(subject.belongs_to?(other)).to be_false }
    end
  end

  describe "#content_as_instance" do
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
