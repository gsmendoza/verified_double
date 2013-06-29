require 'spec_helper'

describe VerifiedDouble::MethodSignature::BooleanValue do
  subject { described_class.new(true) }

  describe "#content_class" do
    it "should be VerifiedDouble::Boolean" do
      expect(subject.content_class).to eq(VerifiedDouble::Boolean)
    end
  end
end
