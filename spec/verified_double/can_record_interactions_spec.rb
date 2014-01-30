require 'spec_helper'

describe VerifiedDouble::CanRecordInteractions do
  let(:a_double){ double('Object') }

  before do
    VerifiedDouble.doubles_in_current_test << a_double
    a_double.extend(VerifiedDouble::CanRecordInteractions)
  end

  describe "#should_receive(method)" do
    it "appends a new method signature with the method to the registry", verifies_contract: 'Object#mocked_fake_to_s()' do
      a_double.should_receive(:mocked_fake_to_s)
      expect(VerifiedDouble.registry.last.method).to eq('mocked_fake_to_s')
      a_double.mocked_fake_to_s
    end

    it 'does not add the result to the current test doubles' do
      a_double.should_receive(:mocked_fake_to_s)
      expect(VerifiedDouble.doubles_in_current_test).to eq([a_double])
      a_double.mocked_fake_to_s
    end
  end

  describe "#stub(method)" do
    it "appends a new method signature with the method to the registry", verifies_contract: 'Object#stubbed_fake_to_s()' do
      a_double.stub(:stubbed_fake_to_s)
      expect(VerifiedDouble.registry.last.method).to eq('stubbed_fake_to_s')
    end

    it 'does not add the result to the current test doubles' do
      a_double.stub(:mocked_fake_to_s)
      expect(VerifiedDouble.doubles_in_current_test).to eq([a_double])
      a_double.mocked_fake_to_s
    end
  end

  describe "#with(*args)" do
    it "sets the args of the last method signature", verifies_contract: 'Object#fake_to_s(Symbol, Symbol)' do
      expect(a_double).to receive(:fake_to_s).with(:arg_1, :arg_2)

      expect(VerifiedDouble.registry.last.args).to be_all{|arg| arg.is_a?(VerifiedDouble::MethodSignature::Value) }
      expect(VerifiedDouble.registry.last.args.map(&:content)).to eq([:arg_1, :arg_2])

      a_double.fake_to_s(:arg_1, :arg_2)
    end
  end

  describe "#and_return(return_value)" do
    it "sets the return value of the last method signature", verifies_contract: 'Object#fake_to_s(Symbol, Symbol)=>Symbol' do
      expect(a_double).to receive(:fake_to_s).with(:arg_1, :arg_2).and_return(:return_value)

      expect(VerifiedDouble.registry.last.return_values).to have(1).return_value
      expect(VerifiedDouble.registry.last.return_values.first).to be_a(VerifiedDouble::MethodSignature::Value)
      expect(VerifiedDouble.registry.last.return_values.first.content).to eq(:return_value)

      a_double.fake_to_s(:arg_1, :arg_2)
    end
  end
end
