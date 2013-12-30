require 'spec_helper'

describe VerifiedDouble::MethodSignature::RspecDoubleValue do
  class Item
  end

  class SuperItem < Item
  end

  let(:class_name) { 'Item' }

  let(:rspec_double) { double(class_name) }
  subject { described_class.new(rspec_double) }

  describe "#content_class" do
    context "where the value is a double" do
      it "is the class represented by the class_name of the recording double" do
        expect(subject.content_class).to eq(Item)
      end
    end

    context 'where the value is an instance double of an inheriting class' do
      let(:rspec_double) { double(SuperItem) }
      subject { described_class.new(rspec_double) }

      it "is the class represented by the class_name of the recording double" do
        expect(subject.content_class).to eq(SuperItem)
      end
    end
  end

  describe "#content_as_instance" do
    it "is the equivalent content_as_instance of the content's class" do
      expect(subject.content_as_instance).to be_a(Item)
    end
  end
end
