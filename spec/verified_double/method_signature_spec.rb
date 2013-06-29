require 'unit_helper'
require 'verified_double/method_signature'

describe VerifiedDouble::MethodSignature do
  class Dummy
  end

  let(:attributes){
    { class_name:  'Dummy',
      method_operator: '#' } }

  describe "#initialize" do
    it { expect(subject.return_values).to be_empty }
    it { expect(subject.args).to be_empty }
  end

  describe "#to_s" do
    subject {
      described_class.new(attributes).tap {|method_signature|
        method_signature.method = 'do_something' } }

    context "when there are args" do
      it "includes the arg values in the result" do
        subject.args = [VerifiedDouble::MethodSignatureValue.new(1), VerifiedDouble::MethodSignatureValue.new({})]
        expect(subject.to_s).to eq("Dummy#do_something(1, {})")
      end
    end

    context "when there are no args" do
      it "displays an empty parenthesis for the args of the result" do
        expect(subject.args).to be_empty
        expect(subject.to_s).to eq("Dummy#do_something()")
      end
    end

    context "when there is a nil arg" do
      it "displays nil for the arg of the result" do
        subject.args = [VerifiedDouble::MethodSignatureValue.new(nil)]
        expect(subject.to_s).to eq("Dummy#do_something(nil)")
      end
    end

    context "where there is a return value" do
      it "displays the return value" do
        subject.return_values = [VerifiedDouble::MethodSignatureValue.new(true)]
        expect(subject.to_s).to eq("Dummy#do_something()=>true")
      end
    end

    context "where there is no return value" do
      it "does not include the hash rocket in the result" do
        expect(subject.return_values).to be_empty
        expect(subject.to_s).to eq("Dummy#do_something()")
      end
    end
  end

  context "multiple method signatures with the same #to_s" do
    let(:method_signature){
      described_class.new(attributes).tap {|method_signature|
        method_signature.method = 'do_something' } }

    let(:method_signature_with_same_to_s){
      described_class.new(attributes).tap {|method_signature|
        method_signature.method = 'do_something' } }

    it { expect(method_signature.to_s).to eq(method_signature_with_same_to_s.to_s) }
    it { expect(method_signature.hash).to eq(method_signature_with_same_to_s.hash) }
    it { expect(method_signature.eql?(method_signature_with_same_to_s)).to be_true }
    it { expect([method_signature, method_signature_with_same_to_s].uniq == [method_signature]).to be_true }
  end

  describe "#belongs_to?(other)" do
    let(:method_signature){
      described_class.new(
        class_name: 'Dummy',
        method_operator: '.',
        method: 'find',
        args: [VerifiedDouble::MethodSignatureValue.new(1)],
        return_values: [VerifiedDouble::MethodSignatureValue.new(Dummy.new)]) }

    subject { method_signature.belongs_to?(other) }

    context "where self has same attributes as other" do
      let(:other){ method_signature.clone }
      it { expect(subject).to be_true }
    end

    context "where self and other have different class names" do
      let(:other){ method_signature.clone.tap{|ms| ms.class_name = 'Object' } }
      it { expect(subject).to be_false }
    end

    context "where self and other have different method operators" do
      let(:other){ method_signature.clone.tap{|ms| ms.method_operator = '#' } }
      it { expect(subject).to be_false }
    end

    context "where self and other have different methods" do
      let(:other){ method_signature.clone.tap{|ms| ms.method = 'destroy' } }
      it { expect(subject).to be_false }
    end

    context "where self and other have different number of args" do
      let(:other){
        method_signature.clone.tap{|ms|
          ms.args = [VerifiedDouble::MethodSignatureValue.new(1), VerifiedDouble::MethodSignatureValue.new(2)] } }

      it { expect(subject).to be_false }
    end

    context "where not all of self's args accept the args of other" do
      let(:other){
        method_signature.clone.tap{|ms|
          ms.args = [VerifiedDouble::MethodSignatureValue.new(2)] } }

      it { expect(subject).to be_false }
    end

    context "where self and other have different number of return values" do
      let(:other){
        method_signature.clone.tap{|ms|
          ms.return_values = [VerifiedDouble::MethodSignatureValue.new(1), VerifiedDouble::MethodSignatureValue.new(2)] } }

      it { expect(subject).to be_false }
    end

    context "where not all of self's return values accept the return values of other" do
      let(:other){
        method_signature.clone.tap{|ms|
          ms.return_values = [VerifiedDouble::MethodSignatureValue.new(Symbol)] } }

      it { expect(subject).to be_false }
    end
  end

  describe "#recommended_verified_signature" do
    let(:method_signature){
      described_class.new(
        class_name: 'Dummy',
        method_operator: '.',
        method: 'find',
        args: [VerifiedDouble::MethodSignatureValue.new(1)],
        return_values: [VerifiedDouble::MethodSignatureValue.new(Dummy.new)]) }

    subject { method_signature.recommended_verified_signature }

    it "is a method signature that is recommended for the user to verify" do
      expect(subject.args[0].value).to eq(method_signature.args[0].recommended_value.value)
      expect(subject.return_values[0].value).to eq(method_signature.return_values[0].recommended_value.value)
    end
  end
end
