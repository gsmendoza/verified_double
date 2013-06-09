require 'unit_helper'
require 'verified_double/get_registered_signatures'

describe VerifiedDouble::GetRegisteredSignatures do
  let(:method_signature_1) {
    VerifiedDouble::MethodSignature.new(class_name: 'Object', method_operator: '#', method: 'to_s') }

  let(:method_signature_2) {
    VerifiedDouble::MethodSignature.new(class_name: 'Object', method_operator: '#', method: 'inspect') }

  let(:recording_double_1) {
    fire_double('VerifiedDouble::RecordingDouble',
      method_signatures: [method_signature_1]) }

  let(:recording_double_2) {
    fire_double('VerifiedDouble::RecordingDouble',
      method_signatures: [method_signature_2]) }

  subject { described_class.new(double_registry) }

  describe "#execute" do
    context "with multiple recording doubles in the registry" do
      let(:double_registry){ [recording_double_1, recording_double_2] }

      it "maps and flattens the method signatures of the recording doubles" do
        expect(subject.execute).to eq([method_signature_1, method_signature_2])
      end
    end

    context "with recording doubles with duplicate signatures" do
      let(:recording_double_2) {
        fire_double('VerifiedDouble::RecordingDouble',
          method_signatures: [method_signature_1]) }

      let(:double_registry){ [recording_double_1, recording_double_2] }

      it "returns distinct method signatures" do
        expect(subject.execute).to eq([method_signature_1])
      end
    end
  end
end
