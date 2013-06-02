require 'unit_helper'
require 'verified_double/report_unverified_signatures'

describe VerifiedDouble::ReportUnverifiedSignatures do
  let(:double_registry) { Set.new }
  let(:nested_example_group) { double('nested_example_group') }

  subject { described_class.new(double_registry, nested_example_group) }

  describe "#initialize" do
    it "requires a double registry and a nested example group" do
      expect(subject.double_registry).to eq(double_registry)
      expect(subject.nested_example_group).to eq(nested_example_group)
    end
  end

  describe "#execute" do
    service_names = [
      :get_registered_signatures,
      :get_verified_signatures,
      :get_unverified_signatures,
      :output_unverified_signatures]

    service_names.each do |service_name|
      service_class_name = "#{VerifiedDouble}::#{service_name.to_s.classify.pluralize}"
      let("#{service_name}_class") { fire_class_double(service_class_name).as_replaced_constant }
      let("#{service_name}_service") { fire_double(service_class_name) }
    end

    it "gets registered and verified signatures and then outputs the unverified signatures" do
      get_registered_signatures_class
        .should_receive(:new)
        .with(double_registry)
        .and_return(get_registered_signatures_service)

      get_verified_signatures_class
        .should_receive(:new)
        .with(nested_example_group)
        .and_return(get_verified_signatures_service)

      get_unverified_signatures_class
        .should_receive(:new)
        .with(get_registered_signatures_service, get_verified_signatures_service)
        .and_return(get_unverified_signatures_service)

      output_unverified_signatures_class
        .should_receive(:new)
        .with(get_unverified_signatures_service)
        .and_return(output_unverified_signatures_service)

      output_unverified_signatures_service.should_receive(:execute)

      subject.execute
    end
  end

end
