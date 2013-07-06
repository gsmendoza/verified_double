require 'spec_helper'

describe VerifiedDouble::SimpleDouble do
  class Dummy
  end

  let(:class_name) {  'Dummy' }
  let(:some_instance_double) { double(class_name) }
  let(:some_class_double) { stub_const(class_name, Class.new) }

  let(:simple_instance_double) { described_class.new(some_instance_double) }
  let(:simple_class_double) { described_class.new(some_class_double) }

  describe "#initialize" do
    it "requires a double" do
      expect(simple_instance_double.internal).to eq(some_instance_double)
    end
  end

  describe "#class_name" do
    context "where the internal double is a double" do
      it "is the name of the class represented by the double" do
        expect(simple_instance_double.class_name).to eq(class_name)
      end
    end

    context "where the internal double is a stub const" do
      it "is the name of the class represented by the class double" do
        expect(simple_class_double.class_name).to eq(class_name)
      end
    end
  end

  describe "#class_double?" do
    it "should be true if the internal double is a class double" do
      expect(simple_instance_double).to_not be_class_double
    end

    it "should be false if the internal double is not an class double" do
      expect(simple_class_double).to be_class_double
    end
  end

  describe "#method_operator" do
    context "when the simple_instance_double wraps an instance double" do
      it "is #" do
        expect(simple_instance_double.method_operator).to eq("#")
      end
    end

    context "when the simple_instance_double wraps a class double" do
      it "is '.'" do
        expect(simple_class_double.method_operator).to eq(".")
      end
    end
  end

  describe "#method_signatures" do
    it "are the method signatures of the double's expected methods" do
      some_instance_double.stub(:save).with(force: true).and_return(false)
      some_instance_double.should_receive(:children).and_return(double('Dummy'))

      simple_instance_double = described_class.new(some_instance_double)

      expect(simple_instance_double.method_signatures.map(&:recommended_verified_signature).map(&:to_s))
        .to eq([
          "Dummy#save(Hash)=>VerifiedDouble::Boolean",
          "Dummy#children()=>Dummy"])

      some_instance_double.children
    end
  end

  describe "#method_doubles" do
    it "returns SimplifiedMethodDoubles from the internal's method doubles" do
      some_instance_double.stub(:save).with(force: true).and_return(false)

      simple_instance_double = described_class.new(some_instance_double)
      expect(simple_instance_double.method_doubles).to have(1).method_double
      expect(simple_instance_double.method_doubles[0]).to be_a(described_class::MethodDouble)
      expect(simple_instance_double.method_doubles[0].internal).to be_a(Hash)
      expect(simple_instance_double.method_doubles[0].double).to eq(simple_instance_double)
      expect(simple_instance_double.method_doubles[0].method).to eq(:save)
    end
  end
end
