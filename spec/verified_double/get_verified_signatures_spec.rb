require 'unit_helper'
require 'verified_double/get_verified_signatures'

describe VerifiedDouble::GetVerifiedSignatures do
  let(:method_signature) { VerifiedDouble::MethodSignature.new }

  let(:nested_example_group){ double(:nested_example_group) }

  let(:parse_method_signature_service) {
    fire_double('VerifiedDouble::ParseMethodSignature') }

  let(:parse_method_signature_service_class) {
    fire_class_double('VerifiedDouble::ParseMethodSignature').as_replaced_constant }

  subject { described_class.new(nested_example_group) }

  describe "#execute" do
    let(:example_with_verified_contract_tag){
      double(:example_with_verified_contract_tag,
        metadata: { verifies_contract: 'signature' }) }

    let(:example_without_verified_contract_tag){
      double(:example_without_verified_contract_tag,
        metadata: { focus: true }) }

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

      expect(subject.execute).to eq([method_signature])
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

      expect(subject.execute).to eq([method_signature])
    end
  end
end


