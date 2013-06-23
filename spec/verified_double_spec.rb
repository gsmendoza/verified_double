require 'unit_helper'
require 'verified_double'

describe VerifiedDouble do
  describe ".registry" do
    it "is an empty array by default" do
      registry = VerifiedDouble.registry
      expect(registry).to eq([])
    end

    it "is memoized" do
      expect(VerifiedDouble.registry).to equal(VerifiedDouble.registry)
    end
  end

  describe ".verified_signatures_from_matchers" do
    it "is an empty array by default" do
      verified_signatures_from_matchers = VerifiedDouble.verified_signatures_from_matchers
      expect(verified_signatures_from_matchers).to eq([])
    end

    it "is memoized" do
      expect(VerifiedDouble.verified_signatures_from_matchers).to equal(VerifiedDouble.verified_signatures_from_matchers)
    end
  end

  describe ".of_instance(class_name, method_stubs={})" do
    let(:class_name){ 'Object' }

    let(:subject) { described_class.of_instance(class_name) }

    after :each do
      VerifiedDouble.registry.clear
    end

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

    context "with method_stubs hash" do
      let(:stubbed_method){ :some_method }
      let(:assumed_output){ :some_output }

      subject { described_class.of_instance(class_name, some_method: assumed_output) }
      
      it "stubs the methods of the instance" do
        expect(subject.send(stubbed_method)).to eq(assumed_output)
      end
    end
  end

  describe ".of_class(class_name)" do
    let(:class_name){ 'Object' }

    let(:subject) { described_class.of_class(class_name) }

    after :each do
      VerifiedDouble.registry.clear
    end

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

    context "with methods hash" do
      let(:stubbed_method){ :some_method }
      let(:assumed_output){ :some_output }

      subject { described_class.of_class(class_name, some_method: assumed_output) }
      
      it "stubs the methods of the class" do
        expect(subject.send(stubbed_method)).to eq(assumed_output)
      end
    end
  end

  describe ".report_unverified_signatures" do
    let(:nested_example_group) { double('nested_example_group') }
    let(:method_signatures_report) { fire_double('VerifiedDouble::MethodSignaturesReport') }
    let(:method_signatures_report_class) {
      fire_class_double('VerifiedDouble::MethodSignaturesReport').as_replaced_constant }
    
    
    it "builds a method signatures report, determines unverified signatures, and ouputs them" do
      nested_example_group
        .stub_chain(:class, :descendant_filtered_examples)
        .and_return([])

      method_signatures_report_class.should_receive(:new).and_return(method_signatures_report)

      actions = [
        :set_registered_signatures,
        :set_verified_signatures_from_tags,
        :set_verified_signatures_from_matchers,
        :merge_verified_signatures,
        :identify_unverified_signatures,
        :output_unverified_signatures]

      actions.each do |action|
        method_signatures_report
          .should_receive(action)
          .and_return(method_signatures_report)
      end

      described_class.report_unverified_signatures(nested_example_group)
    end
  end
end
