require 'rspec/mocks'

require 'verified_double/boolean'
require 'verified_double/matchers'
require 'verified_double/method_signature'
require 'verified_double/method_signature/value'
require 'verified_double/method_signature/boolean_value'
require 'verified_double/method_signatures_report'
require 'verified_double/parse_method_signature'
require 'verified_double/recording_double'
require 'verified_double/relays_to_internal_double_returning_self'

module VerifiedDouble
  extend RSpec::Mocks::ExampleMethods

  def self.of_class(class_name, method_stubs = {})
    class_double = stub_const(class_name, Class.new, transfer_nested_constants: true)
    RecordingDouble.new(class_double, class_name, method_stubs).tap do |double|
      registry << double
    end
  end

  def self.of_instance(class_name, method_stubs = {})
    RecordingDouble.new(double(class_name), class_name, method_stubs).tap do |double|
      registry << double
    end
  end

  def self.registry
    @registry ||= []
  end

  def self.report_unverified_signatures(nested_example_group)
    MethodSignaturesReport.new
      .set_registered_signatures
      .set_verified_signatures_from_tags(nested_example_group)
      .set_verified_signatures_from_matchers
      .merge_verified_signatures
      .identify_unverified_signatures
      .output_unverified_signatures
  end

  def self.verified_signatures_from_matchers
    @verified_signatures_from_matchers ||= []
  end
end

