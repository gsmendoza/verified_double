require 'unit_helper'
require 'verified_double/output_unverified_signatures'

describe VerifiedDouble::OutputUnverifiedSignatures do
  let(:get_unverified_signatures_service){
    fire_double('VerifiedDouble::GetUnverifiedSignatures') }

  let(:unverified_signatures){ %w(UNVERIFIED_SIGNATURES_1 UNVERIFIED_SIGNATURES_2) }

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
      it "should output the unverified_signatures" do
        get_unverified_signatures_service.should_receive(:execute).and_return(unverified_signatures)
        subject.should_receive(:puts).with("The following mocks are not verified:\nUNVERIFIED_SIGNATURES_1\nUNVERIFIED_SIGNATURES_2")

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
