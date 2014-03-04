require 'spec_helper'

describe VerifiedDouble::ExampleMetadata do
  let(:klass) { Object }
  let(:method_signature_string) { '#to_s()=>String' }
  let(:metadata) do
    {
      description_args: ['is a string representing the object'],
      example_group: {
        description_args: [method_signature_string],

        example_group: {
          description_args: ['with some context'],

          example_group: {
            description_args: [klass]
          }
        }
      }
    }
  end

  subject { described_class.new(metadata) }

  describe '#verified_signature' do
    it 'is the class_name and method_signature_string' do
      expect(subject.verified_signature).to eq("#{klass}#{method_signature_string}")
    end
  end

  describe '#described_class' do
    it "is the described class of the metadata's test source" do
      expect(subject.described_class).to eq(klass)
    end

    context "where the described class is a string" do
      let(:klass) { Object.to_s }

      it "should raise an error" do
        expect(-> { subject.described_class }).to raise_error(
          StandardError, "The VerifiedDouble contract spec described class
            'Object' is invalid.
            The described class must be a class or a module."
            .gsub(/\s+/, ' ')
        )
      end
    end
  end

  describe '#method_signature_string' do
    it "is the signature of the method being tested" do
      expect(subject.method_signature_string).to eq(method_signature_string)
    end

    context "where there is no description arg that looks like a method signature" do
      let(:method_signature_string) { 'to_s()=>String' }

      it "should raise an error" do
        expect(-> { subject.method_signature_string }).to raise_error(
          StandardError, "The VerifiedDouble contract spec method 'Object' is
            invalid.
            The method must start with # or .".gsub(/\s+/, ' ')
        )
      end
    end
  end
end

