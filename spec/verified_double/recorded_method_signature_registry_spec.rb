require 'spec_helper'

describe VerifiedDouble::RecordedMethodSignatureRegistry do
  describe "#add_method_signature(a_double, method)" do
    let(:class_name){ 'Object' }
    let(:a_double){ double(class_name) }
    let(:method){ :fake_to_s }
    
    it "adds a method signture matching the method to itself" do
      expect(subject).to be_empty
      
      subject.add_method_signature(a_double, method)

      expect(subject).to have(1).method_signature
      method_signature = subject[0]
      expect(method_signature.class_name).to eq(class_name)
      expect(method_signature.method_operator).to eq('#')
      expect(method_signature.method).to eq(method.to_s)
    end

    it "records the stack frames of the double's caller" do
      subject.add_method_signature(a_double, method)
      expect(subject.first.stack_frame.to_s)
        .to include("./spec/verified_double/recorded_method_signature_registry_spec.rb")
    end
  end
end