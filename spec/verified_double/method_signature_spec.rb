require 'unit_helper'
require 'verified_double/method_signature'

describe VerifiedDouble::MethodSignature do
  describe "#to_s" do
    let(:recording_double) {
      fire_double('VerifiedDouble::RecordingDouble',
        class_name: 'Dummy',
        method_operator: '#') }

    subject {
      described_class.new(recording_double).tap {|method_signature|
        method_signature.method = 'do_something' } }

    context "when there are args" do
      it "includes the args in the result" do
        subject.args = [1, {}]
        expect(subject.to_s).to eq("Dummy#do_something(Fixnum, Hash)")
      end
    end

    context "when there are no args" do
      it "displays an empty parenthesis for the args of the result" do
        expect(subject.return_value).to be_nil
        expect(subject.to_s).to eq("Dummy#do_something()")
      end
    end

    context "when there is a nil arg" do
      it "displays a nil class for the arg of the result" do
        subject.args = [nil]
        expect(subject.to_s).to eq("Dummy#do_something(NilClass)")
      end
    end

    context "where there is a return value" do
      it "displays the return value" do
        subject.return_value = true
        expect(subject.to_s).to eq("Dummy#do_something()=>TrueClass")
      end
    end

    context "where there is no return value" do
      it "does not include the hash rocket in the result" do
        expect(subject.return_value).to be_nil
        expect(subject.to_s).to eq("Dummy#do_something()")
      end
    end
  end
end
