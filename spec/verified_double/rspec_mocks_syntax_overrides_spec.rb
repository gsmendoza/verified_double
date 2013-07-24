require 'spec_helper'

describe VerifiedDouble::RSpecMocksSyntaxOverrides do
  let(:some_method){ 'fake_to_s' }
  let(:some_result){ 'result' }

  describe "#expect(*args)" do
    context "where the double arg records VerifiedDouble interactions" do
      let(:a_double) { VerifiedDouble.of_instance('Object') }

      it "sets the registry's current_double to the first arg", verifies_contract: 'Object#fake_to_s()=>String' do
        expect(VerifiedDouble.registry.current_double).to_not eq(a_double)
        expect(a_double)
        VerifiedDouble.registry.current_double.should eq(a_double)
      end
    end

    context "where the double arg does not record VerifiedDouble interactions" do
      let(:a_double) { double('Object') }

      it "doesn't set the registry's current_double" do
        expect(VerifiedDouble.registry.current_double).to_not equal(a_double)
        expect(a_double)
        expect(VerifiedDouble.registry.current_double).to be_nil
      end
    end
  end

  describe "#allow(*args)" do
    context "where the double arg records VerifiedDouble interactions" do
      let(:a_double) { VerifiedDouble.of_instance('Object') }

      it "sets the registry's current_double to the first arg", verifies_contract: 'Object#fake_to_s()=>String' do
        expect(VerifiedDouble.registry.last).to_not eq(a_double)
        allow(a_double)
        VerifiedDouble.registry.current_double.should eq(a_double)
      end
    end

    context "where the double arg does not record VerifiedDouble interactions" do
      let(:a_double) { double('Object') }

      it "clears registry's current_double" do
        expect(VerifiedDouble.registry.current_double).to_not equal(a_double)
        allow(a_double)
        expect(VerifiedDouble.registry.current_double).to be_nil
      end
    end
  end

  describe "#receive(*args)" do
    context "where the current double is recording VerifiedDouble interactions" do
      let(:a_double) { VerifiedDouble.of_instance('Object') }

      it "adds the first arg as a method signature for the current double" do
        expect(a_double).to receive(some_method).and_return(some_result)

        method_signature = VerifiedDouble.registry.last
        expect(method_signature).to be_a(VerifiedDouble::MethodSignature)
        expect(method_signature.method).to eq(some_method)
        expect(method_signature.return_values.map(&:content)).to eq([some_result])

        a_double.fake_to_s
      end
    end

    context "where the current double is not recording VerifiedDouble interactions" do
      let(:a_double) { double('Object') }

      it "doesn't add a method signature for the method" do
        registry_size = VerifiedDouble.registry.size
        expect(a_double).to receive(some_method).and_return(some_result)

        expect(VerifiedDouble.registry.size).to eq(registry_size)
        a_double.fake_to_s
      end
    end
  end
end