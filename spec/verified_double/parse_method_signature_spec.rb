require 'spec_helper'
require 'verified_double/parse_method_signature'

describe VerifiedDouble::ParseMethodSignature do
  subject { described_class.new(string) }

  describe "#initialize", verifies_contract: 'VerifiedDouble::ParseMethodSignature.new(String)=>VerifiedDouble::ParseMethodSignature' do
    it { expect(described_class.new("Class#method(:arg_1, :arg_2)=>:return_value")).to be_a(VerifiedDouble::ParseMethodSignature) }
  end

  describe "#execute", verifies_contract: 'VerifiedDouble::ParseMethodSignature#execute()=>VerifiedDouble::MethodSignature' do
    let(:string){ "Class#method(:arg_1, :arg_2)=>:return_value" }

    subject { described_class.new(string).execute }

    it "returns a method signature from the signature string" do
      expect(subject).to be_a(VerifiedDouble::MethodSignature)
      expect(subject.class_name).to eq(subject.class_name)
      expect(subject.method_operator).to eq(subject.method_operator)
      expect(subject.method).to eq(subject.method)
      expect(subject.args).to eq(subject.args)
      expect(subject.return_values).to eq(subject.return_values)
    end
  end

  describe "#method_operator" do
    context "for Class.method" do
      let(:string){ "Class.method" }
      it { expect(subject.method_operator).to eq('.') }
    end

    context "for Class#method" do
      let(:string){ "Class#method" }
      it { expect(subject.method_operator).to eq('#') }
    end
  end

  describe "#class_name" do
    context "for Class.method" do
      let(:string){ "Class.method" }
      it { expect(subject.class_name).to eq('Class') }
    end
  end

  describe "#method" do
    context "for Class.method" do
      let(:string){ "Class.method_1!?" }
      it { expect(subject.method).to eq('method_1!?') }
    end

    context "for Class.method(:arg_1, :arg_2)" do
      let(:string){ "Class.method_1!?(:arg_1, :arg_2)" }
      it { expect(subject.method).to eq('method_1!?') }
    end

    context "for Class.method=>return_value" do
      let(:string){ "Class.method_1!?=>return_value" }
      it { expect(subject.method).to eq('method_1!?') }
    end
  end


  describe "#args" do
    context "for Class.method(:arg_1, :arg_2)" do
      let(:string){ "Class.method(:arg_1, :arg_2)" }

      it "builds method signature values from the evals of the args" do
        expect(subject.args.map(&:content)).to eq([:arg_1, :arg_2])
      end
    end

    context "for Class.method" do
      let(:string){ "Class.method" }
      it { expect(subject.args).to eq([]) }
    end

    context "for Class.method=>:return_value" do
      let(:string){ "Class.method=>:return_value" }
      it { expect(subject.args).to eq([]) }
    end
  end

  describe "#return_values" do
    context "for Class.method=>:return_value" do
      let(:string){ "Class.method=>:return_value" }
      it { expect(subject.return_values.map(&:content)).to eq([:return_value]) }
    end

    context "for Class.method" do
      let(:string){ "Class.method" }
      it { expect(subject.return_values).to be_empty }
    end

    context "for Class.method(:arg_1, :arg_2)" do
      let(:string){ "Class.method(:arg_1, :arg_2)" }
      it { expect(subject.return_values).to be_empty }
    end
  end
end
