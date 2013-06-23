require 'unit_helper'
require 'verified_double'
require 'verified_double/method_signatures_report'

describe VerifiedDouble::MethodSignaturesReport do
  describe "#set_registered_signatures" do
    let(:recording_double_1) {
      fire_double('VerifiedDouble::RecordingDouble',
        method_signatures: [method_signature_1]) }

    let(:recording_double_2) {
      fire_double('VerifiedDouble::RecordingDouble',
        method_signatures: [method_signature_2]) }

    let(:method_signature_1) {
      VerifiedDouble::MethodSignature.new(class_name: 'Object', method_operator: '#', method: 'to_s') }

    let(:method_signature_2) {
      VerifiedDouble::MethodSignature.new(class_name: 'Object', method_operator: '#', method: 'inspect') }

    let(:verified_double_module){ fire_class_double('VerifiedDouble')
      .as_replaced_constant(transfer_nested_constants: true) }

    context "with multiple recording doubles in the registry" do
      it "maps and flattens the method signatures of the recording doubles" do
        verified_double_module
          .should_receive(:registry)
          .and_return([recording_double_1, recording_double_2])

        expect(subject.set_registered_signatures.registered_signatures).to eq(
          [method_signature_1, method_signature_2])
      end
    end

    context "with recording doubles with duplicate signatures" do
      let(:recording_double_2) {
        fire_double('VerifiedDouble::RecordingDouble',
          method_signatures: [method_signature_1]) }

      it "returns distinct method signatures" do
        verified_double_module
          .should_receive(:registry)
          .and_return([recording_double_1, recording_double_2])

        expect(subject.set_registered_signatures.registered_signatures).to eq([method_signature_1])
      end
    end
  end

  describe "#set_verified_signatures_from_tags" do
    let(:method_signature) { VerifiedDouble::MethodSignature.new }

    let(:nested_example_group){ double(:nested_example_group) }

    let(:parse_method_signature_service) {
      fire_double('VerifiedDouble::ParseMethodSignature') }

    let(:parse_method_signature_service_class) {
      fire_class_double('VerifiedDouble::ParseMethodSignature').as_replaced_constant }

    let(:example_with_verified_contract_tag){
      double(:example_with_verified_contract_tag,
        metadata: { verifies_contract: 'signature' }) }

    let(:example_without_verified_contract_tag){
      double(:example_without_verified_contract_tag,
        metadata: { focus: true }) }

    subject { described_class.new.set_verified_signatures_from_tags(nested_example_group) }

    it "filters rspec examples with the tag 'verifies_contract'" do
      nested_example_group
        .stub_chain(:class, :descendant_filtered_examples)
        .and_return([example_with_verified_contract_tag, example_without_verified_contract_tag])

      parse_method_signature_service_class
        .should_receive(:new)
        .with(example_with_verified_contract_tag.metadata[:verifies_contract])
        .and_return(parse_method_signature_service)

      parse_method_signature_service
        .should_receive(:execute)
        .and_return(method_signature)

      expect(subject.verified_signatures_from_tags).to eq([method_signature])
    end

    it "returns unique signatures" do
      nested_example_group
        .stub_chain(:class, :descendant_filtered_examples)
        .and_return([example_with_verified_contract_tag, example_with_verified_contract_tag])

      parse_method_signature_service_class
        .should_receive(:new)
        .with(example_with_verified_contract_tag.metadata[:verifies_contract])
        .at_least(:once)
        .and_return(parse_method_signature_service)

      parse_method_signature_service
        .should_receive(:execute)
        .and_return(method_signature)

      expect(subject.verified_signatures_from_tags).to eq([method_signature])
    end
  end

  describe "#identify_unverified_signatures" do
    let(:registered_signature) {
      VerifiedDouble::MethodSignature.new(
        class_name: 'Person',
        method: 'find',
        method_operator: '.',
        args: [VerifiedDouble::MethodSignatureValue.new(1)]) }

    let(:registered_signature_without_match) {
      VerifiedDouble::MethodSignature.new(
        class_name: 'Person',
        method: 'save!',
        method_operator: '#') }

    let(:verified_signature) {
      VerifiedDouble::MethodSignature.new(
        class_name: 'Person',
        method: 'find',
        method_operator: '.',
        args: [VerifiedDouble::MethodSignatureValue.new(Object)]) }

    it "retains registered signatures that cannot accept any of the verified_signatures" do
      expect(registered_signature.accepts?(verified_signature)).to be_true
      expect(registered_signature_without_match.accepts?(verified_signature)).to be_false

      subject.registered_signatures = [registered_signature, registered_signature_without_match]
      subject.verified_signatures = [verified_signature]

      expect(subject.unverified_signatures).to be_empty
      subject.identify_unverified_signatures
      expect(subject.unverified_signatures).to eq([registered_signature_without_match])
    end
  end

  describe "#output_unverified_signatures" do
    class Dummy
    end

    let(:unverified_signatures){ [
      VerifiedDouble::MethodSignature.new(
        class_name: 'Dummy',
        method_operator: '.',
        method: 'find',
        args: [VerifiedDouble::MethodSignatureValue.new(1)],
        return_values: [VerifiedDouble::MethodSignatureValue.new(Dummy.new)]),
      VerifiedDouble::MethodSignature.new(
        class_name: 'Dummy',
        method_operator: '.',
        method: 'where',
        args: [VerifiedDouble::MethodSignatureValue.new(id: 1)],
        return_values: [VerifiedDouble::MethodSignatureValue.new(Dummy.new)]) ] }

    context "where there are no unverified_signatures" do
      it "should not output anything" do
        subject.unverified_signatures = []
        subject.should_not_receive(:puts)
        subject.output_unverified_signatures
      end
    end

    context "where there are unverified_signatures" do
      it "should output the recommended versions of the unverified_signatures" do
        subject.unverified_signatures = unverified_signatures

        lines = [
          "The following mocks are not verified:",
          unverified_signatures[0].recommended_verified_signature,
          unverified_signatures[1].recommended_verified_signature ]

        subject.should_receive(:puts).with(lines.join("\n"))
        subject.output_unverified_signatures
      end
    end
  end

  describe "#set_verified_signatures_from_matchers" do
    let(:verified_double_module){
      fire_class_double('VerifiedDouble')
        .as_replaced_constant(transfer_nested_constants: true) }

    let(:method_signature) { VerifiedDouble::MethodSignature.new }

    it "works" do
      verified_double_module
        .should_receive(:verified_signatures_from_matchers)
        .and_return([method_signature])
      
      expect(subject.set_verified_signatures_from_matchers.verified_signatures_from_matchers)
        .to eq([method_signature])
    end
  end

  describe "#merge_verified_signatures" do
    let(:method_signature_from_tag) { VerifiedDouble::MethodSignature.new }
    let(:method_signature_from_matcher) { VerifiedDouble::MethodSignature.new }

    it "merges the verified signatures from the tags and the matchers" do
      subject.verified_signatures_from_tags = [method_signature_from_tag]
      subject.verified_signatures_from_matchers = [method_signature_from_matcher]

      expect(subject.verified_signatures).to be_empty
      expect(subject.merge_verified_signatures.verified_signatures).to eq([method_signature_from_tag, method_signature_from_matcher])
    end
  end
end
