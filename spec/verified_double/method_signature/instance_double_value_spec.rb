require 'unit_helper'

describe VerifiedDouble::MethodSignature::InstanceDoubleValue do
  class Item
  end

  let(:class_name){ 'Item' }
  let(:some_instance_double){ double(class_name) }
  let(:recording_instance_double) { VerifiedDouble::RecordingDouble.new(some_instance_double, class_name) }
  subject { described_class.new(recording_instance_double) }

  describe "#content_as_instance" do
    it "is the equivalent content_as_instance of the content's class" do
      expect(subject.content_as_instance).to be_a(Item)
    end
  end
end
