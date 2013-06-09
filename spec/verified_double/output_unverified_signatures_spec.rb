require 'unit_helper'
require 'verified_double/output_unverified_signatures'

describe VerifiedDouble::OutputUnverifiedSignatures do
  class Dummy
  end

  let(:get_unverified_signatures_service){
    fire_double('VerifiedDouble::GetUnverifiedSignatures') }

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

  subject { described_class.new(get_unverified_signatures_service) }

  describe "#execute" do
    context "where there are no unverified_signatures" do
      it "should not output anything" do
        get_unverified_signatures_service.should_receive(:execute).and_return([])
        subject.should_not_receive(:puts)

        subject.execute
      end
    end

    context "where there are unverified_signatures" do
      it "should output the recommended versions of the unverified_signatures" do
        get_unverified_signatures_service.should_receive(:execute).and_return(unverified_signatures)

        lines = [
          "The following mocks are not verified:",
          unverified_signatures[0].recommended_verified_signature,
          unverified_signatures[1].recommended_verified_signature ]

        subject.should_receive(:puts).with(lines.join("\n"))
        subject.execute
      end
    end
  end

  describe "#unverified_signatures" do
    it "are the results of get_unverified_signatures.execute" do
      get_unverified_signatures_service.should_receive(:execute).and_return(unverified_signatures)
      expect(subject.unverified_signatures).to eq(unverified_signatures)
    end
  end
end
