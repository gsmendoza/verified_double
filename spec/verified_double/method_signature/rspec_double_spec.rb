require 'spec_helper'

describe VerifiedDouble::MethodSignature::RspecDoubleValue do
  let(:rspec_double) { double('Object') }
  subject { described_class.new(rspec_double) }

  describe "#content_class" do
    context "where the value is a double" do
      it "is the class represented by the class_name of the recording double" do
        expect(subject.content_class).to eq(Object)
      end
    end
  end
end
