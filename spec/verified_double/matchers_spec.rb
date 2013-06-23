require 'unit_helper'
require 'verified_double/matchers'

describe VerifiedDouble::Matchers do
  include VerifiedDouble::Matchers

  after :each do
    VerifiedDouble.verified_signatures_from_matchers.clear
  end

  describe "#verify_accessor_contract(contract)" do
    class Collaborator
      attr_accessor :value
    end

    let(:contract) { 'Collaborator#value()=>String' }

    subject { Collaborator.new }

    it "adds the method signature to the verified signatures from matchers" do
      expect(VerifiedDouble.verified_signatures_from_matchers).to be_empty

      expect(subject).to verify_accessor_contract(contract)

      expect(VerifiedDouble.verified_signatures_from_matchers).to have(1).method_signature
      expect(VerifiedDouble.verified_signatures_from_matchers[0].to_s).to eq(contract)
    end

    context "where the contract has multiple return values" do
      let(:contract) { 'Collaborator#value=>String,Integer' }

      it "complains that the matcher expects only one return value" do
        expect { expect(subject).to verify_accessor_contract(contract) }
          .to raise_error(described_class::CannotHandleMultipleReturnValues)
      end
    end

    context "where the contract return value can be initialized" do
      let(:contract) { 'Collaborator#value=>String' }

      it "assigns the initialized value to the subject's writer and compares it to the subject's reader" do
        expect(subject.value).to be_nil

        expect(subject).to verify_accessor_contract(contract)
        expect(subject.value).to eq(String.new)
      end
    end

    context "where the contract return value is a class which cannot be initialized" do
      let(:contract) { 'Collaborator#value=>Integer' }

      it "assigns the a new object to the subject's writer and compares it to the subject's reader" do
        expect(subject.value).to be_nil

        expect(subject).to verify_accessor_contract(contract)
        expect(subject.value.class).to eq(Object)
      end
    end

    context "where the contract return value is an instance" do
      let(:contract) { 'Collaborator#value=>1' }

      it "assigns the instance to the subject's writer and compares it to the subject's reader" do
        expect(subject.value).to be_nil

        expect(subject).to verify_accessor_contract(contract)
        expect(subject.value).to eq(1)
      end
    end
  end

  describe "#verify_reader_contract" do
    class AnotherCollaborator
      attr_reader :value

      def initialize(value)
        @value = value
      end
    end

    let(:contract) { 'AnotherCollaborator#value()=>String' }
    let(:value) { 'a string' }

    subject { AnotherCollaborator.new(value) }

    it "checks if the method being verified has the same class as the return value" do
      expect(subject).to verify_reader_contract(contract)
    end

    it "adds the method signature to the verified signatures from matchers" do
      expect(VerifiedDouble.verified_signatures_from_matchers).to be_empty

      expect(subject).to verify_reader_contract(contract)

      expect(VerifiedDouble.verified_signatures_from_matchers).to have(1).method_signature
      expect(VerifiedDouble.verified_signatures_from_matchers[0].to_s).to eq(contract)
    end

    context "where the contract has multiple return values" do
      let(:contract) { 'Collaborator#value=>String,Integer' }

      it "complains that the matcher expects only one return value" do
        expect { expect(subject).to verify_reader_contract(contract) }
          .to raise_error(described_class::CannotHandleMultipleReturnValues)
      end
    end
  end
end
