require 'unit_helper'
require 'verified_double/get_unverified_signatures'

describe VerifiedDouble::GetUnverifiedSignatures do
  let(:get_registered_signatures_service){
    fire_double('VerifiedDouble::GetRegisteredSignatures') }

  let(:get_verified_signatures_service){
    fire_double('VerifiedDouble::GetVerifiedSignatures') }

  subject { described_class.new(get_registered_signatures_service, get_verified_signatures_service) }

  describe "#execute" do
    it "subtracts verified_signatures from registered_signatures" do
      get_registered_signatures_service
        .should_receive(:execute)
        .and_return([:verified_signature, :unverified_signature])

      get_verified_signatures_service
        .should_receive(:execute)
        .and_return([:verified_signature])

      expect(subject.execute).to eq([:unverified_signature])
    end
  end
end


