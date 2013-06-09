require 'unit_helper'
require 'verified_double/get_unverified_signatures'

describe VerifiedDouble::GetUnverifiedSignatures do
  let(:get_registered_signatures_service){
    fire_double('VerifiedDouble::GetRegisteredSignatures') }

  let(:get_verified_signatures_service){
    fire_double('VerifiedDouble::GetVerifiedSignatures') }

  subject { described_class.new(get_registered_signatures_service, get_verified_signatures_service) }

  describe "#execute" do
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

      get_registered_signatures_service
        .should_receive(:execute)
        .and_return([registered_signature, registered_signature_without_match])

      get_verified_signatures_service
        .should_receive(:execute)
        .at_least(:once)
        .and_return([verified_signature])

      expect(subject.execute).to eq([registered_signature_without_match])
    end
  end
end


