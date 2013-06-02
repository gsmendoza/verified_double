require 'unit_helper'
require 'verified_double/get_verified_signatures'

describe VerifiedDouble::GetVerifiedSignatures do
  let(:nested_example_group){ double(:nested_example_group) }
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
      expect(subject.execute).to eq([example_with_verified_contract_tag.metadata[:verifies_contract]])
    end

    it "returns unique signatures" do
      nested_example_group
        .stub_chain(:class, :descendant_filtered_examples)
        .and_return([example_with_verified_contract_tag, example_with_verified_contract_tag])
      expect(subject.execute).to eq([example_with_verified_contract_tag.metadata[:verifies_contract]])
    end
  end
end


