require 'unit_helper'
require 'verified_double'

describe VerifiedDouble do
  describe ".registry" do
    it "is a array by default" do
      registry = VerifiedDouble.registry
      expect(registry).to be_a(Array)
    end

    it "is memoized" do
      expect(VerifiedDouble.registry).to equal(VerifiedDouble.registry)
    end
  end

  describe ".of_instance(class_name)" do
    let(:class_name){ 'Object' }

    let(:subject) { described_class.of_instance(class_name) }

    it "creates an instance recording double" do
      expect(subject).to be_a(VerifiedDouble::RecordingDouble)
      expect(subject).to_not be_class_double
      expect(subject.class_name).to eq(class_name)
    end

    it "adds the double to the registry" do
      described_class.registry.clear
      recording_double = subject
      expect(described_class.registry).to eq([recording_double])
    end
  end

  describe ".of_class(class_name)" do
    let(:class_name){ 'Object' }

    let(:subject) { described_class.of_class(class_name) }

    it "creates a class recording double" do
      expect(subject).to be_a(VerifiedDouble::RecordingDouble)
      expect(subject).to be_class_double
      expect(subject.double).to be_a(Module)
      expect(subject.class_name).to eq(class_name)
    end

    it "adds the double to the registry" do
      described_class.registry.clear
      recording_double = subject
      expect(described_class.registry).to eq([recording_double])
    end
  end
end
